module lfsr1024(seed_input, scalar, clk, reset, bs);
inout [9:0] seed_input;
input [9:0] scalar;
input clk, reset;
output bs;

wire tap;
reg [9:0] seed;

always @(posedge clk)begin
    if (reset == 1'b1) begin
        seed <= seed_input;
    end
    else begin
        seed[9] <= seed[8];
		seed[8] <= seed[7];
		seed[7] <= seed[6];
        seed[6] <= seed[5];
        seed[5] <= seed[4];
        seed[4] <= seed[3];
        seed[3] <= seed[2];
        seed[2] <= seed[1];
        seed[1] <= seed[0];
        seed[0] <= tap;
    end
       
end


assign tap = ((seed[7] ^ seed[4]) ^ seed[2]) ^ seed[0];

assign bs = (scalar > seed)?1'b1:1'b0;


endmodule