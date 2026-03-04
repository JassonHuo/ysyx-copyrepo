module code_bcd(
  input [7: 0] in,
  output reg [6: 0] bcd_low,
  output reg [6: 0] bcd_mid,
  output reg [6: 0] bcd_high
);

  always@(*)begin
	case(in % 10)
	  0: bcd_low = 7'b0000001;
	  1: bcd_low = 7'b1001111;
	  2: bcd_low = 7'b0010010;
	  3: bcd_low = 7'b0000110;
	  4: bcd_low = 7'b1001100;
	  5: bcd_low = 7'b0100100;
	  6: bcd_low = 7'b0100000;
	  7: bcd_low = 7'b0001111;
	  8: bcd_low = 7'b0000000;
	  9: bcd_low = 7'b0000100;
	  default: bcd_low = 7'b0000001;
	endcase
	case((in / 10)% 10)
	  0: bcd_mid = 7'b0000001;
	  1: bcd_mid = 7'b1001111;
	  2: bcd_mid = 7'b0010010;
	  3: bcd_mid = 7'b0000110;
	  4: bcd_mid = 7'b1001100;
	  5: bcd_mid = 7'b0100100;
	  6: bcd_mid = 7'b0100000;
	  7: bcd_mid = 7'b0001111;
	  8: bcd_mid = 7'b0000000;
	  9: bcd_mid = 7'b0000100;
	  default: bcd_mid = 7'b0000001;
	endcase
	case(in / 100)
	  0: bcd_high = 7'b0000001;
	  1: bcd_high = 7'b1001111;
	  2: bcd_high = 7'b0010010;
	  3: bcd_high = 7'b0000110;
	  4: bcd_high = 7'b1001100;
	  5: bcd_high = 7'b0100100;
	  6: bcd_high = 7'b0100000;
	  7: bcd_high = 7'b0001111;
	  8: bcd_high = 7'b0000000;
	  9: bcd_high = 7'b0000100;
	  default: bcd_high = 7'b0000001;
	endcase

  end 

endmodule
