module strlig(
  input clk,
  input rst,
  output [15: 0] led
);
  reg [15: 0] temp;
  reg [31: 0] count;
  always@(posedge clk)begin
	//if(rst) temp[15: 0] <= 16'b1;
	if(rst) begin
	  temp[14: 0] <= 15'b0;
	  temp[15] <= 1;
	end
	else begin
	  count <= (count >= 5000000 ? 32'b0: count + 1);
//	  if(count == 0) temp <= {led[14: 0], led[15]};
	  if(count == 0) temp <= {led[0], led[15: 1]};
	end
  end
  assign led = temp;
endmodule
