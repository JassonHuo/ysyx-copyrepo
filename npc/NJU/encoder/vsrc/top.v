module top(
  output no_zero,
  input [7: 0] in,
  input en,
  output [2: 0] out,
  output reg [6: 0] seg
);
  wire [2: 0] enco_out;
  encode83 encoder(
	.x(in),
	.y(enco_out),
	.en(en)
  );

  bcd7seg toseg(
	.b(enco_out),
	.seg(seg)
  );
  assign no_zero = (in != 0);
  assign out = enco_out;
  endmodule  
