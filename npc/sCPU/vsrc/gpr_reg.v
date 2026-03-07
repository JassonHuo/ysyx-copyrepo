module gpr_reg(
  input [1: 0] raddr1_in,
  input [1: 0] raddr2_in,
  output [7: 0] rdata1_out,
  output [7: 0] rdata2_out,
  input [1: 0] waddr,
  input [7: 0] wdata,
  input wen,
  input clk
);

  reg [7: 0] gpr [0: 3];
  always@(posedge clk)begin
	if(wen)
	  gpr[waddr] <= wdata;
  end	  
  
  assign rdata1_out = gpr[raddr1_in];
  assign rdata2_out = gpr[raddr2_in];


endmodule
