module bcd7seg(
  input [2: 0] b,
  output reg [6: 0] seg
);
  
  always@(b)begin
	case(b)
	  0: seg = 7'b0000001;
	  1: seg = 7'b1001111;
	  2: seg = 7'b0010010;
	  default: seg = 7'b0000001;
	endcase
  end
  endmodule
