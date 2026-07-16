module bcd7seg(
  input [2: 0] b,
  output reg [6: 0] seg
);
  
  always@(b)begin
	case(b)
	  0: seg = 7'b0000001;
	  1: seg = 7'b1001111;
	  2: seg = 7'b0010010;
	  3: seg = 7'b0000110;
	  4: seg = 7'b1001100;
	  5: seg = 7'b0100100;
	  6: seg = 7'b0100000;
	  7: seg = 7'b0001111;
	  default: seg = 7'b0000001;
	endcase
  end
  endmodule
