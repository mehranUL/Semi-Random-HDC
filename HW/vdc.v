module vdc10bit(clk, reset, scalar, bs);
input clk,reset;
//output [7:0] vdcout;
input [9:0] scalar;
output bs;

reg [9:0] outcount;
wire [9:0] vdcout;

always@(posedge clk)
begin
    if(reset)
        outcount <= 0;
    else
        outcount <= outcount + 1;
end
assign vdcout [9:0] = {outcount[0],outcount[1],outcount[2],outcount[3],outcount[4],outcount[5],outcount[6],outcount[7],outcount[8],outcount[9]};
assign bs = (scalar > vdcout) ? 1'b1:1'b0;

endmodule