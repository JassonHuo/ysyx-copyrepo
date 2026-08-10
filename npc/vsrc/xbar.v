module xbar(
  input ifu_reqValid,
  output ifu_reqReady,
  input [31: 0] ifu_addr,
  input ifu_respReady,
  output ifu_respValid,
  output reg [31: 0] ifu_rdata,

  input lsu_reqValid,
  output lsu_reqReady,
  input [31: 0] lsu_addr,
  input lsu_wen,
  input [31: 0] lsu_wdata,
  input [3: 0] lsu_mask,
  input lsu_respReady,
  output lsu_respValid,
  output reg [31: 0] lsu_rdata,

  output reg reqValid,
  input reqReady,
  output reg [31: 0] addr,
  output reg wen,
  output reg [31: 0] wdata,
  output reg [3: 0] wmask,
  input respValid,
  output respReady,
  input [31: 0] rdata
);

  always@(*)begin
	reqValid = 0;
	addr = 0;
	wen = 1'b0;
	wmask = 4'b0;
	wdata = 32'b0;
	if(ifu_reqValid)begin
	  reqValid = ifu_reqValid;
	  addr = ifu_addr;
	  wen = 1'b0;
	  wmask = 4'b0;
	  wdata = 32'b0;
	end
	else if(lsu_reqValid)begin
	  reqValid = lsu_reqValid;
	  addr = lsu_addr;
	  wen = lsu_wen;
	  wmask = lsu_mask;
	  wdata = lsu_wdata;
	end
  end

  assign ifu_respValid = respValid;
  assign lsu_respValid = respValid;
  assign ifu_reqReady = reqReady;
  assign lsu_reqReady = reqReady;
  assign respReady = ifu_respReady | lsu_respReady;

  always@(*)begin
	lsu_rdata = 32'b0;
	ifu_rdata = 32'b0;
	if(lsu_respReady)
	  lsu_rdata = rdata;
	else if(ifu_respReady)
	  ifu_rdata = rdata;
  end

endmodule
