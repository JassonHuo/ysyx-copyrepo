module seg(
  input [2: 0] data,
  output reg [6: 0] seg
);

  always@(*)begin
	case(data)
	  3'b0: seg = 7'b1111111;
	  default: seg = 7'b0000000;
	endcase
  end

endmodule
