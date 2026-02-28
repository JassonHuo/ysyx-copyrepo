module strlig(
  input clk,
  input rst,
  output [15: 0] led
);

  always@(posedge clk)begin
	if(rst) led = 16'b1;
	else begin
	  led = {led[14: 0], led[15]};
	end
  end
endmodule
