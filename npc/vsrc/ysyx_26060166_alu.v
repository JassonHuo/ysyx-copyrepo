`include "global.vh"
module ysyx_26060166_alu(
  input [31: 0] x,
  input [31: 0] y,
  input is_signed,
  input [3: 0] alu_op,
  output reg [31: 0] z,
  output zero
);

  assign zero = (z == 32'b0);
  wire bigger = (is_signed ? $signed(x) > $signed(y): x > y);
  wire smaller = (is_signed ? $signed(x) < $signed(y): x < y);
  wire equal = (x == y);

  always@(*)begin
	case(alu_op)
	  `ALU_ADD: z = x + y;
	  `ALU_SUB: z = x - y;
	  `ALU_AND: z = x & y;
	  `ALU_OR : z = x | y;
	  `ALU_XOR: z = x ^ y;
	  `ALU_LEFT: z = x << y[4: 0];
//	  `ALU_RIGHT: z = (is_signed ? ($signed(x)) >>> y : x >> y);
	  `ALU_RIGHT: begin
		if(is_signed)
		  z = $signed(x) >>> y[4: 0];
		else
		  z = x >> y[4: 0];
	  end
	  `ALU_LARGE: z = {31'b0, bigger};
	  `ALU_SMALL: z = {31'b0, smaller};
	  `ALU_EQUAL: z = {31'b0, equal};
	  `ALU_NEQUAL: z = {31'b0, ~equal};
	  `ALU_LAREQ: z = {31'b0, ~smaller};
	  `ALU_STOP: z = 32'b0;
	  default: z = 32'b0;
	endcase
  end


endmodule
