module bcd(
  input [3: 0] data,
  output reg [6: 0] out
);

  always@(data)begin
	case(data)
	  4'd0: out = 7'b0000001;
	  4'd1: out = 7'b1001111;
	  4'd2: out = 7'b0010010;
	  4'd3: out = 7'b0000110;
	  4'd4: out = 7'b1001100;
	  4'd5: out = 7'b0100100;
	  4'd6: out = 7'b0100000;
	  4'd7: out = 7'b0001111;
	  4'd8: out = 7'b0000000;
	  4'd9: out = 7'b0000100;
	  4'ha: out = 7'b0001000;
	  4'hb: out = 7'b1100000;
	  4'hc: out = 7'b0110001;
	  4'hd: out = 7'b1000010;
	  4'he: out = 7'b0110000;
	  4'hf: out = 7'b0111000;
	  default: out = 7'b0000001;
	endcase
  end

endmodule
