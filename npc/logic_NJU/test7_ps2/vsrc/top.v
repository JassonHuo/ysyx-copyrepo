module top(
  input clk,
  input clr,
  input ps2_clk,
  input ps2_data,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3,
  output [6: 0] seg4,
  output [6: 0] seg5,
  output [6: 0] seg6,
  output [6: 0] seg7,
  output overflow
);

  wire [7: 0] data_kbd;
  wire ready;
  reg nextdata_n;
  parameter NONE = 0, PRESS = 1, WAIT = 2;
  reg [1: 0] state, next_state;
  reg reading;
  reg [7: 0] data;
  reg [7: 0] data_reg;
  reg [15: 0] counter;

  ps2_keyboard my_kbd(
	.clk(clk),
	.clrn(~clr),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.data(data_kbd),
	.ready(ready),
	.nextdata_n(nextdata_n),
	.overflow(overflow)
  );

//  wire [7: 0] data = data_kbd & {8{ready}};

  always@(*)begin
	if(clr) next_state = NONE;
	else begin
	  case(state)
		NONE: next_state = (data == 0 ? NONE: PRESS);
		PRESS: next_state = (data == 8'hF0 ? WAIT: PRESS);
		WAIT: next_state = (data == 8'h0 ? WAIT: NONE);
		default: next_state = NONE;
	  endcase
	end
  end

  reg [1: 0] prev_state;

  always@(posedge clk)begin
	prev_state <= state;
//	$display(data);
//	$display(data_kbd);
	if(state != prev_state)
	  $display("%h, %h", state, data);
	if(clr)
	  state <= NONE;
	else begin
	  state <= next_state;
	end
  end

  seg_out seg00(
	.data(data_reg[3: 0]),
	.down(state != PRESS || data == 8'hF0),
	.seg(seg0)
  );

  seg_out seg01(
	.data(data_reg[7: 4]),
	.down(state != PRESS || data == 8'hF0),
	.seg(seg1)
  );

  always@(posedge clk)begin
	nextdata_n <= 1'b1;
	data <= 8'b0;
	if(ready)begin
	  data <= data_kbd;
	  nextdata_n <= 1'b0;
	  if(data_kbd != 8'hF0)
		data_reg <= data_kbd;
	end
	if(!nextdata_n)
	  data <= 8'b0;
  end

  always@(posedge clk)begin
	if(state == NONE && next_state == PRESS)
	  counter <= counter + 1;
  end

  seg_out seg20(
	.data(counter[3: 0]),
	.down(1'b0),
	.seg(seg4)
  );

  seg_out seg21(
	.data(counter[7: 4]),
	.down(1'b0),
	.seg(seg5)
  );

  seg_out seg22(
	.data(counter[11: 8]),
	.down(1'b0),
	.seg(seg6)
  );

  seg_out seg23(
	.data(counter[15: 12]),
	.down(1'b0),
	.seg(seg7)
  );

  reg [7: 0] ascii;

  always@(*)begin
	case(data_reg)
	  8'h15: ascii = "q";
	  8'h1d: ascii = "w";
	  8'h24: ascii = "e";
	  8'h2d: ascii = "r";
	  8'h2c: ascii = "t";
	  8'h35: ascii = "y";
	  8'h3c: ascii = "u";
	  8'h43: ascii = "i";
	  8'h44: ascii = "o";
	  8'h4d: ascii = "p";
	  8'h1c: ascii = "a";
	  8'h1b: ascii = "s";
	  8'h23: ascii = "d";
	  8'h2b: ascii = "f";
	  8'h34: ascii = "g";
	  8'h33: ascii = "h";
	  8'h3b: ascii = "j";
	  8'h42: ascii = "k";
	  8'h4b: ascii = "l";
	  8'h1a: ascii = "z";
	  8'h22: ascii = "x";
	  8'h21: ascii = "c";
	  8'h2a: ascii = "v";
	  8'h32: ascii = "b";
	  8'h31: ascii = "n";
	  8'h3a: ascii = "m";
	  8'h16: ascii = "1";
	  8'h1e: ascii = "2";
	  8'h26: ascii = "3";
	  8'h25: ascii = "4";
	  8'h2e: ascii = "5";
	  8'h36: ascii = "6";
	  8'h3d: ascii = "7";
	  8'h3e: ascii = "8";
	  8'h46: ascii = "9";
	  8'h45: ascii = "0";
	  default: ascii = 8'h0;
	endcase
  end

  seg_out seg10(
	.data(ascii[3: 0]),
	.down(state != PRESS|| data == 8'hF0),
	.seg(seg2)
  );

  seg_out seg11(
	.data(ascii[7: 4]),
	.down(state != PRESS || data == 8'hF0),
	.seg(seg3)
  );

endmodule
