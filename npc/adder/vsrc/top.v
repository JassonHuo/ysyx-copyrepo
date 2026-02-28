module top(
  input x[3: 0],
  input y[3: 0],
  output z[3: 0],
  output cout
);
  wire out0, out1, out2;
  sig_adder adder1(
	.x(x[0]),
	.y(y[0]),
	.cin(0),
	.z(z[0]),
	.cout(out0)
  );
  sig_adder adder2(
	.x(x[1]),
	.y(y[1]),
	.cin(out0),
	.z(z[1]),
	.cout(out1)
  );
  sig_adder adder3(
	.x(x[2]),
	.y(y[2]),
	.cin(out1),
	.z(z[2]),
	.cout(out2)
  );
  sig_adder adder4(
	.x(x[3]),
	.y(y[3]),
	.cin(out2),
	.z(z[3]),
	.cout(cout)
  );
  endmodule
