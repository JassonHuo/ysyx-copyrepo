module top(
  input rst,
  input clk,
  output [6: 0] bcd_low,
  output [6: 0] bcd_high,
  output [7: 0] out
);

  reg [7: 0] tmp;

  always@(posedge clk)begin
	if(rst) tmp <= 8'b1;
	else begin
	  if(tmp == 8'b0) 
		tmp <= 8'b1;
	  else 
		tmp <= {(tmp[7] ^ tmp[5] ^ tmp[4] ^ tmp[3]), tmp[7: 1]}; 
	end	  
  end
  assign out = tmp;
  code_bcd bcd1(
	.in(tmp),
	.bcd_low(bcd_low),
	.bcd_high(bcd_high)
  );

endmodule
