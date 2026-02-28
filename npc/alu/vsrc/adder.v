module adder(
  input [7: 0] x,
  input [7: 0] y,
  output [7: 0] z,
  output cout
);
  wire out0, out1, out2, out3, out4, out5, out6;
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
	.cout(out3)
  );
   sig_adder adder4(
	.x(x[4]),
	.y(y[4]),
	.z(z[4]),
	.cin(out3),
	.cout(out4)
  ) ;
  sig_adder adder5(
	.x(x[5]),
	.y(y[5]),
	.z(z[5]),
	.cin(out4),
	.cout(out5)
  );
  
   sig_adder adder6(
	.x(x[6]),
	.y(y[6]),
	.z(z[6]),
	.cin(out5),
	.cout(out6)
  );
   sig_adder adder7(
	.x(x[7]),
	.y(y[7]),
	.z(z[7]),
	.cin(out6),
	.cout(cout)
  );
  endmodule  
