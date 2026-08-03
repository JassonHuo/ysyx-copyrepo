module memory #(ADDR_WIDTH = 1, DATA_WIDTH = 1) (
  input clk,
  input [DATA_WIDTH-1:0] wdata,
  input [ADDR_WIDTH-1:0] waddr,
  input [ADDR_WIDTH-1:0] raddr1,
  input [ADDR_WIDTH-1:0] raddr2,
  output reg [DATA_WIDTH-1:0] rdata1,
  output reg [DATA_WIDTH-1:0] rdata2,
  input wen
);

  wire [DATA_WIDTH - 1: 0] reg_data1;
  wire [DATA_WIDTH - 1: 0] reg_data2;
  RegisterFIle #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_WIDTH(DATA_WIDTH)
  ) mem (
	.clk(clk),
	.wdata(wdata),
	.waddr(waddr),
	.raddr1(raddr1),
	.raddr2(raddr2),
	.rdata1(reg_data1),
	.rdata2(reg_data2),
	.wen(wen)
  );

  always@(posedge clk)begin
	rdata1 <= reg_data1;
	rdata2 <= reg_data2;
  end

endmodule
