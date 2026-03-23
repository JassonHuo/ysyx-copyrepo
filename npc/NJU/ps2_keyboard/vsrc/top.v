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
  output [6: 0] seg4,
  output [6: 0] seg5,
  output [6: 0] seg6,
  output [6: 0] seg7,
  output reg [7: 0] data_out
);

  reg nextdata_n;
  wire [7: 0] data_in;
  wire ready;
  reg [7: 0] data;

  reg [15: 0] counter;
  reg down;

  ps2_keyboard pkbd(
	.clk(clk),
	.clrn(~rst),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.nextdata_n(nextdata_n),
	.data(data_in),
	.ready(ready),
	.overflow(overflow)
  );

  bcd bcd0(
	.data({result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7]}),
	.clk(clk),
	.bcd_low(seg0),
	.bcd_high(seg1),
	.down(down)
  );

  bcd bcd1(
	.data({data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]}),
	.clk(clk),
	.bcd_low(seg2),
	.bcd_high(seg3),
	.down(down)
  );

  bcd bcd2(
	.data({counter[8], counter[9], counter[10], counter[11], counter[12], counter[13], counter[14], counter[15]}),
	.clk(clk),
	.bcd_low(seg4),
	.bcd_high(seg5),
	.down(0)
  );

  bcd bcd3(
	.data({counter[0], counter[1], counter[2], counter[3], counter[4], counter[5], counter[6], counter[7]}),
	.clk(clk),
	.bcd_low(seg6),
	.bcd_high(seg7),
	.down(0)
  );


  reg [7: 0] result;


  assign data_out = result;

  always@(posedge clk)begin
	if(data_in != 8'hf0)
	  data <= data_in;
	if(data_in == data)
	  counter <= counter;
	else
	  counter <= counter + 1;
  end
  
  always@(posedge clk)begin
	if(rst)begin
	  nextdata_n <= 1'b1;
	  counter <= 0;
	end
	else begin
	  nextdata_n <= 1'b1;
	  if(ready == 1)begin
		down <= 0;
		nextdata_n <= ~ready;
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
		  8'h4b: result <= "L";
		  8'h1a: result <= "Z";
		  8'h22: result <= "X";
		  8'h21: result <= "C";
		  8'h2a: result <= "V";
		  8'h32: result <= "B";
		  8'h31: result <= "N";
		  8'h3a: result <= "M";
		  8'h16: result <= "1";
		  8'h1e: result <= "2";
		  8'h26: result <= "3";
		  8'h25: result <= "4";
		  8'h2e: result <= "5";
		  8'h36: result <= "6";
		  8'h3d: result <= "7";
		  8'h3e: result <= "8";
		  8'h46: result <= "9";
		  8'h45: result <= "0";

		  default:begin
			result <= 0;
			down <= 1;
		  end
		endcase
	  end
	  else 
		down <= 1;
	end
  end
endmodule
