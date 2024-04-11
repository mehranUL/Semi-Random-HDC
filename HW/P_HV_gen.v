module P_HV_gen (clk, reset, scalar, out_p);

input clk, reset;
input reg [9:0] scalar;
output out_p;

wire bs_vdc, Q_T;

vdc10bit vdc(clk, reset, scalar, bs_vdc);
jk_ff TFF(bs_vdc, bs_vdc, clk, Q_T);

assign out_p = bs_vdc ^ Q_T;


endmodule