module top(
  input rst,
  input clk,
  input stop,
  output [6: 0] bcd_low,
  output [6: 0] bcd_high,
  output [7: 0] out
);

  reg [7: 0] tmp;
  reg [7: 0] cycle_num;

  always@(posedge clk)begin
	if(rst)begin
	  tmp <= 8'b1;
	  cycle_num <= 0;
	end
	else begin
	  if(stop == 0)begin
	  if(tmp == 8'b0) 
		tmp <= 8'b1;
	  else 
		if(cycle_num <= 255)begin
		  tmp <= {(tmp[4] ^ tmp[3] ^ tmp[2] ^ tmp[0]), tmp[7: 1]}; 
		  cycle_num <= cycle_num + 1;
		end
	  end	
	end	  
  end
  assign out = tmp;
  code_bcd bcd1(
	.in(tmp),
	.bcd_low(bcd_low),
	.bcd_high(bcd_high)
  );

endmodule
