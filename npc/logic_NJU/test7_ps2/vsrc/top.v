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
//	if(state != prev_state)
//	  $display("%h, %h", state, data);
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
	if(data != 0)
	  $display("receive: %h", data);
	nextdata_n <= 1'b1;
	data <= 8'b0;
	data_reg <= data_kbd;
	if(ready && !reading)begin
	  nextdata_n <= 1'b0;
	  reading <= 1'b1;
	  data <= 8'b0;
	end
	else if(ready && reading)begin
	  data <= data_kbd;
	  reading <= 1'b0;
	end
	else begin
	  reading <= 1'b0;
	  data <= 8'b0;
	end
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

endmodule
