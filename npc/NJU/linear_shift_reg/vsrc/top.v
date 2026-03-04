module top(
  input rst,
  input clk,
  output [6: 0] bcd_low,
  output [6: 0] bcd_high,
  output [7: 0] out
);

  reg [7: 0] tmp;
  reg [20: 0] counter;
  reg [7: 0] cycle_num;

  always@(posedge clk)begin
	if(counter == 0)begin
	if(rst)begin
	  tmp <= 8'b01110100;
	  cycle_num <= 0;
	  counter <= 0;
	end
	else begin
	  if(tmp == 8'b0) 
		tmp <= 8'b01110100;
	  else 
		if(cycle_num <= 255)begin
		  tmp <= {(tmp[4] ^ tmp[3] ^ tmp[2] ^ tmp[0]), tmp[7: 1]}; 
		  cycle_num <= cycle_num + 1;
		end
		
	end	  
  end
  else counter <= (counter >= 5000 ? 0: counter + 1);
  end
  assign out = tmp;
  code_bcd bcd1(
	.in(tmp),
	.bcd_low(bcd_low),
	.bcd_high(bcd_high)
  );

endmodule
