`include "global.vh"
module alu(
  input [31: 0] x,
  input [31: 0] y,
  input [3: 0] alu_op,
  output reg [31: 0] z,
  output zero
);

  always@(*)begin
	case(alu_op)
	  `ALU_ADD: z = x + y;
	  `ALU_STOP: z = 32'b0;
	  default: z = 32'b0;
	endcase
  end

  assign zero = (z == 32'b0);

endmodule
