module top(
  input rst,
  input clk,
  input ps2_data,
  input ps2_clk,
  output overflow,
  output reg [6: 0] seg0, seg1, seg2, seg3,
  output reg [6: 0] seg4, seg5, seg6, seg7
);

  reg nextdata_n;
  wire [7: 0] data_kbd;
  wire ready;
  parameter NONE = 0, PRESS = 1, WAIT = 2;
  reg [1: 0] state, next_state; 
  reg [7: 0] data; 
  reg reading;

  ps2_keyboard kbd(
	.clk(clk),
	.clrn(~rst),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.nextdata_n(nextdata_n),
	.data(data_kbd),
	.ready(ready),
	.overflow(overflow)
  );	

  always@(*)begin
	if(rst)
	  next_state = NONE;
	else begin
	  case(state)
		NONE: next_state = (data == 8'b0 ? NONE: (data == 8'hF0 ? WAIT: PRESS));
		PRESS: next_state = (data == 8'hF0 ? WAIT: PRESS);
		WAIT: next_state = (data == 8'b0 || data == 8'hF0 ? WAIT: NONE);
		default: next_state = NONE;
	  endcase
	end
  end

  always@(posedge clk)begin
	nextdata_n <= 1'b1;
	$display(state);
//	$display("%h", data);
	if(rst)begin
	  state <= NONE;
	  data <= 8'b0;
	  reading <= 1'b1;
	end
	else begin
	  if(nextdata_n)
		reading <= 1'b0;
	  state <= next_state;
	  reading <= 1'b1;
	  if(ready) begin
		if(~reading)
		  data <= data_kbd;
		else
		  nextdata_n <= 1'b0;
	  end
	  else begin
		data <= 8'b0;
	  end
	end
  end

endmodule
