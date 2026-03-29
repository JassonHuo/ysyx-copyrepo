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
  reg [7: 0] data_in;
  wire [7: 0] data_kbd;
  reg [7: 0] use_data;
  reg down;

  always@(*)begin
	case(state)
	  NONE: next_state = (data_in == 8'b0) ? NONE: DOWN;
	  DOWN: next_state = (data_in == 8'hF0) ? WAIT: DOWN;
	  WAIT: next_state = (data_in == 8'hF0) ? WAIT: NONE;
	  default: next_state = NONE;
    endcase
  end

  always@(posedge clk)begin
	if(state != next_state)
	  $display("%d", next_state);
	if(~rstn)begin
	  state <= NONE;
	end
	else begin
	  state <= next_state;
	end
  end

  always@(posedge clk)begin
	if(~rstn)begin
	  nextdata_n <= 1;
	  data_in <= 8'b0;
	end	 
	else begin
	  if(ready && nextdata_n)begin
		nextdata_n <= 1'b0;
		data_in <= data_kbd;
	  end
	  else if(!ready)begin
		nextdata_n <= 1'b1;
		data_in <= data_in;
	  end
	end	  
  end

  always@(*)begin
	case(state)
	  NONE:begin
		down = 1;
	  end
	  DOWN:begin
		down = 0;
	  end
	  WAIT:begin
		down = 1;
	  end
	  default:
		down = 1;
	endcase
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
	.data({use_data[0], use_data[1], use_data[2], use_data[3], use_data[4], use_data[5], use_data[6], use_data[7]}),
	.clk(clk),
	.down(down),
	.bcd_low(seg0),
	.bcd_high(seg1)
  );

endmodule
