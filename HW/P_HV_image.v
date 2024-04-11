module P_HV_image (clk, reset, scalar, out_p);

input clk, reset;
input [9:0] scalar [0:143];
output [143:0] out_p;

wire bs_vdc [0:143], Q_T [0:143];

genvar i;
generate
for (i=0; i<144; i = i+1)begin
	vdc10bit vdc(clk, reset, scalar[i],bs_vdc[i]);
	jk_ff TFF(bs_vdc[i], bs_vdc[i], clk, Q_T[i]);
	assign out_p[i] = bs_vdc[i] ^ Q_T[i];
	
end

endgenerate

/* vdc10bit vdc(clk, reset, scalar, bs_vdc);
jk_ff TFF(bs_vdc, bs_vdc, clk, Q_T);

assign out_p = bs_vdc ^ Q_T; */


endmodule