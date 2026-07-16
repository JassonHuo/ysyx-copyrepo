module top(
  input [3: 0] x,
  input [3: 0] y,
  input [2: 0] sel,
  output reg [3: 0] z
);

  wire [3: 0] adder_result;

  adder adder0(
	.x(x),
	.y(y),
	.z(adder_result),
	.sel(sel[0])
  );

  always@(*)begin
	z = 0;
	case(sel)
	  3'b0, 3'b1: z = adder_result;
	  3'h2: z = ~x;
	  3'h3: z = x & y;
	  3'h4: z = x | y;
	  3'h5: z = x ^ y;
	  3'h6: z = {3'b0, (x < y)};
	  3'h7: z = {3'b0, (x == y)};
	  default: z = 0;
	endcase

  end

endmodule
