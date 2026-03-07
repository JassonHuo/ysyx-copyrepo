module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  input rst,
  output overflow,
  output [6: 0] seg0,
  output [6: 0] seg1
);

//  wire nextdata_n, ready;
  wire [7: 0] data;
  ps2_keyboard kb1(
	.clk(clk),
	.clrn(rst),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.ready(),
	.nextdata_n(1),
	.overflow(overflow),
	.data(data)
  );

  bcd bcd1(
	.clk(clk),
	.rst(rst),
	.data(data),
	.bcd_low(seg0),
	.bcd_high(seg1)
  );

    

endmodule
