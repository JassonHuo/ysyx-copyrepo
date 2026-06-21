module gpr(
  input clk,
  input [31: 0] wdata,
  input [3: 0] waddr,
  input [3: 0] raddr1,
  input [3: 0] raddr2,
  output [31: 0] rdata1,
  output [31: 0] rdata2,
  input wen
);

  RegisterFile #(4, 32) Gpr
  (
	.clk(clk),
	.wdata(wdata),
	.waddr(waddr),
	.raddr1(raddr1),
	.raddr2(raddr2),
	.rdata1(rdata1),
	.rdata2(rdata2),
	.wen(wen)
  );

endmodule
