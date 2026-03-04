module top(
  input in,
  input clk,
  input rst,
  output out1,
  output out2, 
  output out3,
  output out4
);

  reg q1, q2, q3, q4;

  always@(posedge clk)begin

	if (rst == 0) begin
	  q1 <= 0;
	  q2 <= 0;
	  q3 <= 0;
	  q4 <= 0;
	end
	else begin
	  q1 <= in;
	  q2 <= q1;
	  q3 <= q2;
	  q4 <= q3;	
	end

  end

  assign out1 = q1;
  assign out2 = q2;
  assign out3 = q3;
  assign out4 = q4;

endmodule
