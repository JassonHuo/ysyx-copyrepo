module top(
  input clk,
  output [2: 0] west,
  output [2: 0] north,
  output [6: 0] seg0,
  output [6: 0] seg1
);

  reg [3: 0] counter1;
  reg [3: 0] counter0;
  reg [1: 0] state;
  reg [1: 0] next_state;

  parameter A = 0, B = 1, C = 2, D = 3;

  wire counter_zero = (counter0 == 0 && counter1 == 0);
  reg [7: 0] counter = {counter1, counter0};

  always@(posedge clk)begin
	state <= next_state;
	if(state == A && next_state == B)
	  counter <= 8'h04;
	else if(state == B && next_state == C)
	  counter <= 8'h19;
	else if(state == C && next_state == D)
	  counter <= 8'h04;
	else if(state == D && next_state == A)
	  counter <= 8'h29;
	else begin
	  counter0 <= (counter0 == 0 ? 9: counter0 - 1);
	  counter1 <= (counter0 == 0 ? counter1 - 1: counter1);
	end 
  end

  assign west[0] = (state == A);
  assign west[1] = (state == B);
  assign west[2] = (state == C || state == D);

  assign north[0] = (state == C);
  assign north[1] = (state == D);
  assign north[2] = (state == A || state == B);

  always@(*)begin
	case(state)
	  A: next_state = (counter_zero ? B: A);
	  B: next_state = (counter_zero ? C: B);
	  C: next_state = (counter_zero ? D: C);
	  D: next_state = (counter_zero ? A: D);
	  default: next_state = A;
	endcase
  end

  bcd bcd0(
	.data(counter0),
	.down(1'b0),
	.bcd_out(seg0)
  );

  bcd bcd1(
	.data(counter1),
	.down(1'b0),
	.bcd_out(seg1)
  );

endmodule
