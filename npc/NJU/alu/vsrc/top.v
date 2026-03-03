module top(
  input [3: 0] x,
  input [3: 0] y,
  input [2: 0] sel,
  output reg [3: 0] z,
  output reg overflow,
  output reg cout
);


  wire [3: 0] z_add;
  wire over_add, cout_add;

  add_suber op1(
	.x(x),
	.y(y),
	.cin(sel[0]),
	.overflow(over_add),
	.cout(cout_add),
	.z(z_add)
  );

  always@(*)begin
	overflow = 0;
	cout = 0;
	case(sel)

	  3'b0, 3'b1:begin
		overflow = over_add;
		cout = cout_add;
		z = z_add;
	  end 
	  3'b10: z = ~x;
	  3'b11: z = x & y;
	  3'b100: z = x | y;
	  3'b101: z = x ^ y;
	  3'b110: z = (x < y) ? 1: 0;
	  3'b111: z = (x == y) ? 1: 0;
	  default: z = 0;

	endcase
  end	

endmodule
