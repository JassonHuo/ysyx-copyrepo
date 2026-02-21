module strlig(
  input clk,
  input rst,
  output [15: 0] led
);
  reg [15: 0] temp;
  always@(posedge clk)begin
	if(rst) temp[15: 0] <= 16'b1;
	else begin
	 temp <= {led[14: 0], led[15]};
	end
  end
  assign led = temp;
endmodule
