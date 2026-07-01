module fre_div(
  input clk,
  output reg clk_out
);

  reg [63: 0] counter;
  always@(posedge clk)begin
	  counter <= (counter == 0 ? 64'd100000000000: 64'b0);
	  clk_out <= (counter != 0 ? clk_out: ~clk_out);
  end


endmodule
