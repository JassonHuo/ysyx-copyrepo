module adder(
  input [3: 0] x,
  input [3: 0] y,
  output [3: 0] z,
  output cout
);
  wire out0, out1, out2;
  sig_adder adder0(
	.x(x[0]),
	.y(y[0]),
	.z(z[0]),
	.cin(0),
	.cout(out0)
  );
  sig_adder adder1(
	.x(x[1]),
	.y(y[1]),
	.z(z[1]),
	.cin(out0),
	.cout(out1)
  );
  sig_adder adder2(
	.x(x[2]),
	.y(y[2]),
	.z(z[2]),
	.cin(out1),
	.cout(out2)
  );
  sig_adder adder3(
	.x(x[3]),
	.y(y[3]),
	.z(z[3]),
	.cin(out2),
	.cout(cout)
  );
  endmodule  
