module pc_reg(
  input clk,
  input rst,
  input pc_en,
  input [3: 0] pc_addr_in,
  output reg [3: 0] pc_out
);

  always@(posedge clk)begin
	if(rst)
	  pc_out <= 0;
	else if(pc_en == 1)
	  pc_out <= pc_addr_in;
	else
	  pc_out <= pc_out + 1;
  end

endmodule
