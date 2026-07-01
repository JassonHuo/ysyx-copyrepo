module fre_div(
  input clk,
  output clk_out
);

  reg [32: 0] counter;
  always@(posedge clk)begin
	counter <= (counter == 0 ? 1000000000: 0);
  end

  assign clk_out = (counter != 0 ? clk_out: ~clk_out);

endmodule
