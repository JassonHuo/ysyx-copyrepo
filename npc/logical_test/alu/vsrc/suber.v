module suber(
  input [3: 0] x, 
  input [3: 0] y,
  output [3: 0] z,
  output cout
);
  wire [3: 0] nega_y;
  adder add1(
	.x(~y),
	.y(4'b1),
	.z(nega_y),
	/* verilator lint_off PINCONNECTEMPTY */
	.cout()
	/* verilator lint_on PINCONNECTEMPTY */
  );

  adder add2(
	.x(x),
	.y(nega_y),
	.z(z),
	.cout(cout)
  );

  endmodule
