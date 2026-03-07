module gpr_reg(
  input [1: 0] raddr1_in,
  input [1: 0] raddr2_in,
  output [7: 0] rdata1_out,
  output [7: 0] rdata2_out,
  input [1: 0] waddr,
  input [7: 0] wdata,
  input wen,
  input clk,
  output [7: 0] reg0,
  output [7: 0] reg1,
  output [7: 0] reg2,
  output [7: 0] reg3
//  output [7: 0] tmp
);

  reg [7: 0] gpr [0: 3];
  always@(posedge clk)begin
	if(wen)
	  gpr[waddr] <= wdata;
  end	  
  
  assign rdata1_out = gpr[raddr1_in];
  assign rdata2_out = gpr[raddr2_in];

  assign reg0 = gpr[0];

  assign reg1 = gpr[1];

  assign reg2 = gpr[2];

  assign reg3 = gpr[3];

 // assign tmp = gpr[2];

endmodule
