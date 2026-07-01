module fre_div(
  input clk,
  output reg clk_out
);

  reg [63: 0] counter;
  always@(posedge clk)begin
	  counter <= (counter == 0 ? 64'd1000000000000000: counter - 1);
	  clk_out <= (counter != 0 ? clk_out: ~clk_out);
  end


endmodule
