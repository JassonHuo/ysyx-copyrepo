module top(
  input clk,
  input ps2_clk,
  input rst,
  input ps2_data,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3,
  output overflow
);

  wire [7: 0] data; 
  wire ready;
  
  ps2_keyboard kbd(
	.clk(clk),
	.clrn(rst),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.data({data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]}),
	.ready(ready),
	.nextdata_n(1'b0),
	.overflow(overflow)
  );
  
  bcd bcd0(
	.data(data[3: 0]),
	.out(seg0)
  );

  bcd bcd1(
	.data(data[7: 4]),
	.out(seg1)
  );

  reg [7: 0] asc;
   
  always@(data)begin
	if(ready)begin
	case(data)
	  //字母与空格
	  8'h15: asc = "q";
	  8'h1d: asc = "w";
	  8'h24: asc = "e";
	  8'h2d: asc = "r";
	  8'h2c: asc = "t";
	  8'h35: asc = "y";
	  8'h3c: asc = "u";
	  8'h43: asc = "i";
	  8'h44: asc = "o";
	  8'h4d: asc = "p";
	  8'h1c: asc = "a";
	  8'h1b: asc = "s";
	  8'h23: asc = "d";
	  8'h2b: asc = "f";
	  8'h34: asc = "g";
	  8'h33: asc = "h";
	  8'h3b: asc = "j";
	  8'h42: asc = "k";
	  8'h4b: asc = "l";
	  8'h1a: asc = "z";
	  8'h22: asc = "x";
	  8'h21: asc = "c";
	  8'h2a: asc = "v";
	  8'h32: asc = "b";
	  8'h31: asc = "n";
	  8'h3A: asc = "m";
	  8'h29: asc = " ";

	  //功能键
	  8'h3b: asc = 0;
	  8'h3c: asc = 0;
	  8'h3d: asc = 0;
	  8'h3e: asc = 0;
	  8'h3f: asc = 0;
	  8'h40: asc = 0;
	  8'h41: asc = 0;
	  8'h42: asc = 0;
	  8'h43: asc = 0;
	  8'h44: asc = 0;
	  8'h85: asc = 0;
	  8'h86: asc = 0;

	  //第一排数字
	  8'h29: asc = 8'h60;
	  8'h02: asc = 8'h31;
	  8'h03: asc = 8'h32;
	  8'h04: asc = 8'h33;
	  8'h05: asc = 8'h34;
	  8'h06: asc = 8'h35;
	  8'h07: asc = 8'h36;
	  8'h08: asc = 8'h37;
	  8'h09: asc = 8'h38;
	  8'h0a: asc = 8'h39;
	  8'h0b: asc = 8'h30;
	  8'h0c: asc = 8'h2d;
	  8'h0d: asc = 8'h3d; 

	  //操作按键
	  8'h01: asc = 8'h1b;
	  8'h0e: asc = 8'h08;
	  8'h0f: asc = 8'h09;
	  8'h1c: asc = 8'h0d;

	  //符号
	  8'h1a: asc = 8'h5b;
	  8'h1b: asc = 8'h5d;
	  8'h27: asc = 8'h3b;
	  8'h28: asc = 8'h27;
	  8'h2b: asc = 8'h5c;
	  8'h33: asc = 8'h2c;
	  8'h34: asc = 8'h2e;
	  8'h35: asc = 8'h2f;

	  default: asc = "0";
	endcase
  end
  end

  bcd bcd2(
	.data(asc[3: 0]),
	.out(seg2)
  );

  bcd bcd3(
	.data(asc[7: 4]),
	.out(seg3)
  );

endmodule
