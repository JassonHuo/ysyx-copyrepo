module top(
  input [7: 0] data,
  input [2: 0] sel,
  input in,
  input clk,
  output [7: 0] out
);

  reg [7: 0] temp;
  always@(posedge clk)begin
	case(sel)
	  3'b000: temp <= 8'b0;
	  3'b001: temp <= data;
	  3'b010: temp <= {1'b0, temp[7: 1]};
	  3'b011: temp <= {temp[6: 0], 1'b0};
	  3'b100: temp <= {temp[7], temp[7: 1]};
	  3'b101: temp <= {in, temp[7: 1]};
	  3'b110: temp <= {temp[0], temp[7: 1]};
	  3'b111: temp <= {temp[6: 0], temp[7]};
	  default: temp <= 8'b0;  
	endcase
  end
  assign out = temp[7: 0] & {8{sel == 101}};

endmodule
