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

  parameter A = 0, B = 1, C = 2, D = 3;

  reg [2: 0] state, next_state;
  wire ready;
  reg nextdata_n;
  reg [7: 0] data_in;
  reg [7: 0] prev_data;
  reg [7: 0] use_data;
  reg down;

  always@(*)begin
	$display("%d",state);
	case(state)
	  A: next_state = (data_in == 8'b0) ? A: B;
	  B: next_state = (data_in == 8'b0) ? A: (data_in == prev_data ? C: (data_in == 8'hF0 ? D: B));
	  C: next_state = (data_in == 8'b0) ? A: (data_in == prev_data ? C: (data_in == 8'hF0 ? D: C));
	  D: next_state = A;
	  default: next_state = A;
	endcase
  end

  always@(posedge clk)begin
	if(~rstn)begin
	  state <= A;
	  prev_data <= 8'b0;
	end
	else begin
	  state <= next_state;
	  prev_data <= data_in;
	end
  end

  always@(posedge clk)begin
	if(~rstn)begin
	  nextdata_n <= 1;
	end	 
	else begin
	  if(ready && nextdata_n)
		nextdata_n <= 1'b0;
	  else
		nextdata_n <= 1'b1;
	end	  
  end

  always@(*)begin
	case(state)
	  A:begin
		down = 1;
		use_data = 8'b0;
	  end
	  B:begin
		use_data = data_in;
		down = 0;
	  end
	  C:begin
		use_data = data_in;
		down = 0;
	  end
	  default:begin
		use_data = 8'b0;
		down = 1;
	  end
	endcase
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
	.data({use_data[0], use_data[1], use_data[2], use_data[3], use_data[4], use_data[5], use_data[6], use_data[7]}),
	.clk(clk),
	.down(down),
	.bcd_low(seg0),
	.bcd_high(seg1)
  );

endmodule
