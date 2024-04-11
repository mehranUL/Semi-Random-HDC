module unary_gen #(parameter width=10)(scalar, clk, reset, u_out, out_count);
input [7:0] scalar;
input clk, reset;
output reg u_out;
output reg [width-1:0] out_count;
//output reg [width-1:0] u_total;

wire [width-1:0] temp;


assign temp = scalar << (width-8);

always @(posedge clk) begin
	if (reset || (out_count == (2**width)-1)) begin
		out_count <= 0;
	end else begin
		out_count <= out_count + 1;
        //temp <= scalar << 1;
        u_out <= (out_count < temp)? 1'b1 : 1'b0;
	end
end

//always @(posedge clk) begin
  //  if (out_count == (2**width)-1)
    //    out_count <= 0;
//end
//integer i=1;
//always @(posedge clk) begin
  //  if (!reset) begin
    //    out_count <= out_count + 1;
        //temp <= scalar << 1;
      //  u_out <= (out_count < temp)? 1'b1 : 1'b0;
    //end
        

//end


endmodule