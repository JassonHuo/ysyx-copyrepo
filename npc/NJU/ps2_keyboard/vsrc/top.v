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
  wire [7: 0] data_kbd;
//  reg [7: 0] use_data;
  reg down;
  reg used;
  reg [7: 0] data_in;
  reg ready_prev;

  always@(posedge clk)begin
	  $display("%d", state);
	  if(!rstn)begin
		state <= NONE;
		nextdata_n <= 1'b1;
		down <= 1;
		used <= 0;
	  end
	  else begin
		ready_prev <= ready;
		nextdata_n <= 1'b1;
		if(ready && !used)begin
		  data_in <= data_kbd;
		  nextdata_n <= 1'b0;
		  used <= 1'b1;
		  down <= 1'b0;
		  case(state)
			NONE:begin
			  if(data_kbd == 8'b0)begin
				state <= NONE;
				down <= 1'b1;
			  end
			  else if(data_kbd == 8'hF0)begin
				state <= WAIT;
				down <= 1'b1;
			  end
			  else begin
				state <= DOWN;
				down <= 1'b0;
			  end
			end
			DOWN:begin
			  down <= 0;
			  if(data_kbd == 8'hF0)begin
				state <= WAIT;
				down <= 1'b1;
			  end
			  else begin
				state <= DOWN;
				down <= 1'b0;
			  end
			end
			WAIT:begin
			  if(data_kbd == 8'b0)begin
				state <= WAIT;
				down <= 1'b1;
			  end
			  else begin
				state <= NONE;
				down <= 1'b1;
			  end
			end
			default:begin
			  state <= NONE;
			  down <= 1'b1;
			end
		  endcase
		end
		else 
		  used <= 1'b0;
	  end
/*		else if(!ready)begin
		  used <= 1'b0;
		  nextdata_n <= 1'b1;
		end
		else begin
		  nextdata_n <= 1'b1;
		end
		*/
	  end
  
  ps2_keyboard kbd0(
	.clk(clk),
	.clrn(rstn),
	.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),
	.nextdata_n(nextdata_n),
	.data(data_kbd),
	.ready(ready),
	.overflow(overflow)
  );

  bcd bcd0(
	.data(data_in),
	.clk(clk),
	.down(down),
	.bcd_low(seg0),
	.bcd_high(seg1)
  );

endmodule
