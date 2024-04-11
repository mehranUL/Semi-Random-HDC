module random_flip(
  input [1023:0] input_reg,
  input clk,
  input reset,
  output reg [1023:0] output_reg
);


//reg [3:0] lfsr_state;
  //initial begin
	//lfsr_state = 64'hACE1_35F2_4BD7_A912;
  //end
  //reg [63:0] lfsr_state = 32'hACE1_35F2;
  //reg [63:0] flip_mask;
integer i;
  always @(posedge clk) begin
    if (reset)
        output_reg <= 0;
    else begin
        //output_reg <= input_reg;
        output_reg <= {input_reg[511:0], ~input_reg[5], input_reg[1023:516], ~input_reg[2], ~input_reg[11], ~input_reg[14]};

        //for ( i = 0; i < 4; i = i+1) begin
          //  if (lfsr_state[2]) begin
            //    output_reg[lfsr_state%16] <= ~input_reg[lfsr_state%16];
            //end
         //end
      
      //lfsr_state[i] <= lfsr_state[0] ^ lfsr_state[1] ^ lfsr_state[2] ^ lfsr_state[31];
        //lfsr_state = {lfsr_state[1:0], lfsr_state[0] ^ lfsr_state[3]};
      //lfsr_state = {lfsr_state[30:0], flip_mask[i]};
     end
  end

endmodule