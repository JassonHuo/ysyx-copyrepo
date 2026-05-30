module top(
  input clk,
  input clr,
  input ps2_clk,
  input ps2_data,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3,
  output overflow
);

  wire [7: 0] data_kbd;
  wire ready;
  reg nextdata_n;
  parameter NONE = 0, PRESS = 1, WAIT = 2;
  reg [1: 0] state, next_state;
  reg reading;
  reg [7: 0] data;

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
	  endcase
	end
  end

  always@(posedge clk)begin
//	$display(state);
//	$display(data);
//	$display(data_kbd);
//	if(state != next_state)
//	  $display(next_state);
	$display(data);
	if(clr)
	  state <= NONE;
	else begin
	  state <= next_state;
	end
  end

  seg_out seg00(
	.data(data_kbd[3: 0]),
	.down(state != PRESS),
	.seg(seg0)
  );

  seg_out seg01(
	.data(data_kbd[7: 4]),
	.down(state != PRESS),
	.seg(seg1)
  );

  always@(posedge clk)begin
	nextdata_n <= 1'b1;
	if(ready && !reading)begin
	  nextdata_n <= 1'b0;
	  reading <= 1'b1;
	end
	else if(ready && reading)begin
	  data <= data_kbd;
	  reading <= 1'b0;
	end
	else begin
	  reading <= 1'b1;
	end
  end

endmodule
