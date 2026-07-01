module fre_div(
  input clk,
  output reg clk_out
);

  reg [31: 0] counter;
  always@(posedge clk)begin
	  counter <= (counter == 0 ? 32'd50000000: 32'b0);
    clk_out <= (counter != 0 ? clk_out: ~clk_out);
  end


endmodule
