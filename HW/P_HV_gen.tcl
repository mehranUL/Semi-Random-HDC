#/**************************************************/
#/* Compile Script for Synopsys                    */
#/* dc_shell-t -f compile_dc.tcl                   */
#/*                                                */
#/* M. Hassan Najafi                               */
#/**************************************************/
set First_Path "/home/C00505755/Documents/LD_Synopsys/VDC_HDC"

#/* All verilog files, separated by spaces         */

set my_verilog_files [list  $First_Path/P_HV_gen.v $First_Path/jk_ff.v $First_Path/vdc.v]
set my_toplevel P_HV_gen

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk

#set clock period 
set my_clk_prd_ns 0.43
#0.61

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0.1

# UID-401 is a warning: Design rule attributes from the driving cell will be set on the port. (UID-401)
#suppress_errors = { UID-401 }
set auto_wire_load_selection false
#Set automatic removal of constant flipflop(s) 
set compile_seqmap_propagate_constants false 
#Set automatic removal of unloaded flipflop(s) 
set compile_delete_unloaded_sequential_cells false
#to prevent register merging on all registers in your design
set compile_enable_register_merging false

#hdlin_ff_always_sync_set_reset = true
#hdlin_translate_off_skip_text = true

#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/

#===========================================================
#14nm Technology 
#set OSU_FREEPDK "/home/C00505755/Documents/HDC_Synopsys/14nmLibrary/"

#32nm Technology 
#set OSU_FREEPDK "/home/C00505755/Documents/HDC_Synopsys/32nmLibrary/"

#45nm Technology 
set OSU_FREEPDK "/home/C00505755/Documents/HDC_Synopsys/45nmLibrary/FreePDK45/osu_soc/lib/files"
#===========================================================

set search_path [concat  $search_path $OSU_FREEPDK]
set alib_library_analysis_path $OSU_FREEPDK

#===========================================================
#14nm Technology 
#set link_library [set target_library [concat  [list saed14rvt_tt0p8v25c.db] [list dw_foundation.sldb]]]
#set target_library "saed14rvt_tt0p8v25c.db"

#32nm Technology 
#set link_library [set target_library [concat  [list saed32rvt_tt1p05v25c.db] [list dw_foundation.sldb]]]
#set target_library "saed32rvt_tt1p05v25c.db"

#45nm Technology 
set link_library [set target_library [concat  [list gscl45nm.db] [list dw_foundation.sldb]]]
set target_library "gscl45nm.db"
#===========================================================


define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"

analyze -f sverilog $my_verilog_files
elaborate $my_toplevel
current_design $my_toplevel
link
uniquify

#set my_period [expr 1000 / $my_clk_freq_MHz]
set my_period $my_clk_prd_ns

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

#===========================================================
#14nm
#set_driving_cell  -lib_cell SAEDRVT14_INV_1  [all_inputs]	

#32nm
#set_driving_cell  -lib_cell INVX1_RVT  [all_inputs]

#45nm
set_driving_cell  -lib_cell INVX1  [all_inputs]
#===========================================================

set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

compile_ultra 

check_design


redirect change_names \
{ change_names -rules verilog -hierarchy -verbose }

set filename [format "%s%s"  $my_toplevel ".vo"]
write -format verilog -hierarchy -output Outputs_P_HV_gen/$filename

set filename [format "%s%s"  $my_toplevel ".ddc"]
write -format ddc -hierarchy -o Outputs_P_HV_gen/$filename


redirect Outputs_P_HV_gen/timing_P_HV.txt { report_timing -transition_time}
redirect Outputs_P_HV_gen/power_P_HV.txt { report_power }
#redirect Outputs_P_HV_gen/area_P_HV.txt { report_area }
report_timing

quit
