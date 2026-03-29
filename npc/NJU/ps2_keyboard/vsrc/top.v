module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  input rstn,
  output overflow,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3,
  output [6: 0] seg4,
  output [6: 0] seg5,
  output [6: 0] seg6,
  output [6: 0] seg7
);

  parameter NONE = 0, DOWN = 1, WAIT = 2;

  reg [2: 0] state, next_state;
  wire ready;
  reg nextdata_n;
  wire [7: 0] data_in;
  reg [7: 0] use_data;
  reg down;
  reg used;

  always@(posedge clk)begin
	  $display("%d", state);
	  if(!rstn)begin
		state <= NONE;
		nextdata_n <= 1'b1;
		down <= 1;
		used <= 0;
	  end
	  else begin
		nextdata_n <= 1'b1;
		if(ready && !used)begin
		  nextdata_n <= 1'b0;
		  used <= 1'b1;
		  down <= 1'b1;
		  case(state)
			NONE:begin
			  if(data_in == 8'b0)
				state <= NONE;
			  else
				state <= DOWN;
			  end
			DOWN:begin
			  down <= 0;
			  use_data <= data_in;
			  if(data_in == 8'hF0)
				state <= WAIT;
			  else
				state <= DOWN;
			end
			WAIT:begin
			  if(data_in == 8'b0)
				state <= WAIT;
			  else
				state <= NONE;
			end
		  endcase
		end
		else if(!ready)begin
		  used <= 1'b0;
		end
	  end
  end
  
  ps2_keyboard kbd0(
	.clk(clk),
	.clrn(rstn),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.nextdata_n(nextdata_n),
	.data(data_in),
	.ready(ready),
	.overflow(overflow)
  );

  bcd bcd0(
	.data(use_data),
	.clk(clk),
	.down(down),
	.bcd_low(seg0),
	.bcd_high(seg1)
  );

endmodule
