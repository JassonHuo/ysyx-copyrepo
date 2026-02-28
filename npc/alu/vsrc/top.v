module top(
  input [7: 0] x,
  input [7: 0] y,
  input [1: 0] sel, //00 add; 01 sub; 10 and; 11 or
  output [7: 0] z,
  output cout,
  output zf
);
  wire[7: 0] add, sub, _or, _and;
  wire cout_add, cout_sub;
  adder add_solution(
	.x(x),
	.y(y),
	.z(add),
	.cout(cout_add)
  );

  suber sub_solution(
	.x(x),
	.y(y),
	.z(sub),
	.cout(cout_sub)
  );

  ormodule or_solution(
	.x(x),
	.y(y),
	.z(_or)
  );

  andmodule and_solution(
	.x(x),
	.y(y),
	.z(_and)
  );

  compare comp(
	.x(x),
	.y(y),
	.zf(zf)
  );

  assign z = (sel == 0) ? add: (sel == 1 ? sub: (sel == 2 ? _and: _or));
  assign cout = (sel == 0) ? cout_add: (sel == 1 ? cout_sub: 0);
  endmodule
