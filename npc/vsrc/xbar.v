module xbar(
  input ifu_reqValid,
  input [31: 0] ifu_addr,
  input ifu_respValid,
  output reg [31: 0] ifu_rdata,

  input lsu_reqValid,
  input [31: 0] lsu_addr,
  input lsu_wen,
  input [31: 0] lsu_wdata,
  input [3: 0] lsu_wmask,
  input lsu_respValid,
  output reg [31: 0] lsu_rdata,

  output reg reqValid,
  output reg [31: 0] addr,
  output reg wen,
  output reg [31: 0] wdata,
  output reg [3: 0] wmask,
  output respValid,
  input [31: 0] rdata
);

  always@(*)begin
	reqValid = 1'b0;
	addr = 32'b0;
	wen = 1'b0;
	wdata = 32'b0;
	wmask = 4'b0;
	lsu_rdata = 32'b0;
	ifu_rdata = 32'b0;
	respValid = 1'b0;
	if(ifu_reqValid)begin
	  reqValid = ifu_reqValid;
	  addr = ifu_addr;
	  wen = 1'b0;
	  wdata = 32'b0;
	  wmask = 4'b0;
	end
	else if(lsu_reqValid)begin
	  reqValid = lsu_reqValid;
	  addr = lsu_addr;
	  wen = lsu_wen;
	  wdata = lsu_wdata;
	  wmask = lsu_wmask;
	end
	else begin
	  reqValid = 1'b0;
	  addr = 32'b0;
	  wen = 1'b0;
	  wdata = 32'b0;
	  wmask = 4'b0;
	  lsu_rdata = 32'b0;
	  ifu_rdata = 32'b0;
	end

	if(ifu_respValid)begin
	  ifu_rdata = rdata;
	end
	else if(lsu_respValid)begin
	  lsu_rdata = rdata;
	end
  end
  
endmodule
