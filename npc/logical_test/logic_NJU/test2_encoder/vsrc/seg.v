module seg(
  input [2: 0] data,
  output reg [6: 0] seg
);

  always@(*)begin
	case(data)
	  3'h0: seg = 7'b0000001;
	  3'h1: seg = 7'b1001111;
	  3'h2: seg = 7'b0010010;
	  3'h3: seg = 7'b0000110;
	  3'h4: seg = 7'b1001100;
	  3'h5: seg = 7'b0100100;
	  3'h6: seg = 7'b0100000;
	  3'h7: seg = 7'b0001111;
	  default: seg = 7'b0000001;
	endcase
  end

endmodule
