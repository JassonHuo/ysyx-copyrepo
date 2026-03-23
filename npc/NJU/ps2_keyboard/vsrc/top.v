module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  input rst,
  output overflow,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3,
  output reg [7: 0] data_out
);

  reg nextdata_n;
  wire [7: 0] data;
  wire ready;


  ps2_keyboard pkbd(
	.clk(clk),
	.clrn(~rst),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.nextdata_n(nextdata_n),
	.data({data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]}),
	.ready(ready),
	.overflow(overflow)
  );

  bcd bcd0(
	.data(result),
	.clk(clk),
	.bcd_low(seg0),
	.bcd_high(seg1)
  );

  bcd bcd1(
	.data(data),
	.clk(clk),
	.bcd_low(seg2),
	.bcd_high(seg3)
  );


  reg [7: 0] result;
  reg reading;

  assign data_out = data;
  
  always@(posedge clk)begin
	if(~rst)begin
	  reading <= 1'b0;
	  nextdata_n <= 1'b1;
	  result <= 8'b0;
	end
	else begin
	    nextdata_n <= 1'b1;
	  if(ready == 1 && reading == 0)begin
		nextdata_n <= 1'b0;
		reading <= 1'b1;
		case(data)
		  8'h15: result <= "Q";
		  8'h1d: result <= "W";
		  8'h24: result <= "E";
		  8'h2d: result <= "R";
		  8'h2c: result <= "T";
		  8'h35: result <= "Y";
		  8'h3c: result <= "U";
		  8'h43: result <= "I";
		  8'h44: result <= "O";
		  8'h4d: result <= "P";
		  8'h1c: result <= "A";
		  8'h1b: result <= "S";
		  8'h23: result <= "D";
		  8'h2b: result <= "F";
		  8'h34: result <= "G";
		  8'h33: result <= "H";
		  8'h3b: result <= "J";
		  8'h42: result <= "K";
		  default:begin
			result <= 8'b0;
			reading <= 1'b0;
		  end
		endcase
	  end
	  else begin
		reading <= 1'b0;
		result <= result;
	  end
	end
  end

endmodule
