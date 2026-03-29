module bcd(
  input [7: 0] data,
  input clk,
  input down,
  output reg [6: 0] bcd_low,
  output reg [6: 0] bcd_high
);

  wire [7: 0] data_rev;
  
  always@(posedge clk)begin
	if(down)begin
	  bcd_low <= 7'b1111111;
	  bcd_high <= 7'b1111111;
	end
	else begin
	case(data[3: 0])
	  0: bcd_low <= 7'b0000001;
	  1: bcd_low <= 7'b1001111;
	  2: bcd_low <= 7'b0010010;
	  3: bcd_low <= 7'b0000110;
	  4: bcd_low <= 7'b1001100;
	  5: bcd_low <= 7'b0100100;
	  6: bcd_low <= 7'b0100000;
	  7: bcd_low <= 7'b0001111;
	  8: bcd_low <= 7'b0000000;
	  9: bcd_low <= 7'b0000100;
	  10: bcd_low <= 7'b0001000;
	  11: bcd_low <= 7'b1100000;
	  12: bcd_low <= 7'b0110001;
	  13: bcd_low <= 7'b1000010;
	  14: bcd_low <= 7'b0110000;
	  15: bcd_low <= 7'b0111000;
	  default: bcd_low <= 7'b0000001;
	endcase
	case(data[7: 4])
	  0: bcd_high <= 7'b0000001;
	  1: bcd_high <= 7'b1001111;
	  2: bcd_high <= 7'b0010010;
	  3: bcd_high <= 7'b0000110;
	  4: bcd_high <= 7'b1001100;
	  5: bcd_high <= 7'b0100100;
	  6: bcd_high <= 7'b0100000;
	  7: bcd_high <= 7'b0001111;
	  8: bcd_high <= 7'b0000000;
	  9: bcd_high <= 7'b0000100;
	  10: bcd_high <= 7'b0001000;
	  11: bcd_high <= 7'b1100000;
	  12: bcd_high <= 7'b0110001;
	  13: bcd_high <= 7'b1000010;
	  14: bcd_high <= 7'b0110000;
	  15: bcd_high <= 7'b0111000;
	  default: bcd_high <= 7'b0000001;
	endcase
  end
  end

endmodule
