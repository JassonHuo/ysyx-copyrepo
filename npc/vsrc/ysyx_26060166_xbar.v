module ysyx_26060166_xbar(
  input clk,

  output ifu_arReady,
  input ifu_arValid,
  input [31:0] ifu_araddr,
  input [3:0] ifu_arid,//
  input [7:0] ifu_arlen,//
  input [2:0] ifu_arsize,//
  input [1:0] ifu_arburst,//
  input ifu_rReady,
  output ifu_rValid,
  output reg [1:0] ifu_rresp,
  output [31:0] ifu_rdata,
  output ifu_rlast,//
  output [3:0] ifu_rid,//

  output lsu_awReady,
  input lsu_awValid,
  input [31:0] lsu_awaddr,
  input [3:0] lsu_awid,
  input [7:0] lsu_awlen,
  input [2:0] lsu_awsize,
  input [1:0] lsu_awburst,
  output lsu_wReady,
  input lsu_wValid,
  input [31:0]lsu_wdata,
  input [3:0] lsu_wstrb,
  input lsu_wlast,
  input lsu_bReady,
  output lsu_bValid,
  output  [1:0] lsu_bresp,
  output  [3:0] lsu_bid ,
  output lsu_arReady,
  input lsu_arValid,
  input [31:0] lsu_araddr,
  input [3:0] lsu_arid,
  input [7:0] lsu_arlen,
  input [2:0] lsu_arsize,
  input [1:0] lsu_arburst,
  input lsu_rReady,
  output lsu_rValid,
  output [1:0] lsu_rresp,
  output reg [31:0] lsu_rdata,
  output lsu_rlast,
  output [3:0] lsu_rid,

  input  io_master_awReady,
  output reg io_master_awValid,
  output reg [31:0] io_master_awaddr,
  output [3:0] io_master_awid,
  output [7:0] io_master_awlen,
  output [2:0] io_master_awsize,
  output [1:0] io_master_awburst,
  input io_master_wReady,
  output io_master_wValid,
  output reg [31:0]io_master_wdata,
  output reg [3:0] io_master_wstrb,
  output io_master_wlast,
  output io_master_bReady,
  input io_master_bValid,
  input  [1:0] io_master_bresp,
  input  [3:0] io_master_bid ,
  input io_master_arReady,
  output io_master_arValid,
  output [31:0] io_master_araddr,
  output [3:0] io_master_arid,
  output [7:0] io_master_arlen,
  output [2:0] io_master_arsize,
  output [1:0] io_master_arburst,
  output io_master_rReady,
  input io_master_rValid,
  input [1:0] io_master_rresp,
  input [31:0] io_master_rdata,
  input io_master_rlast,
  input [3:0] io_master_rid,

  input  clint_awReady,
  output clint_awValid,
  output [31:0] clint_awaddr,
  output [3:0] clint_awid,
  output [7:0] clint_awlen,
  output [2:0] clint_awsize,
  output [1:0] clint_awburst,
  input clint_wReady,
  output clint_wValid,
  output [31:0]clint_wdata,
  output [3:0] clint_wstrb,
  output clint_wlast,
  output clint_bReady,
  input clint_bValid,
  input  [1:0] clint_bresp,
  input  [3:0] clint_bid ,
  input clint_arReady,
  output clint_arValid,
  output [31:0] clint_araddr,
  output [3:0] clint_arid,
  output [7:0] clint_arlen,
  output [2:0] clint_arsize,
  output [1:0] clint_arburst,
  output clint_rReady,
  input clint_rValid,
  input [1:0] clint_rresp,
  input [31:0] clint_rdata,
  input clint_rlast,
  input [3:0] clint_rid
);

  wire awReady;
  wire awValid;
  wire [31:0] awaddr;
  wire [3:0] awid;
  wire [7:0] awlen;
  wire [2:0] awsize;
  wire [1:0] awburst;
  wire wReady;
  wire wValid;
  wire [31:0]wdata;
  wire [3:0] wstrb;
  wire wlast;
  wire bReady;
  wire bValid;
  wire [1:0] bresp;
  wire [3:0] bid ;
  wire arReady;
  reg arValid;
  reg [31:0] araddr;
  reg [3:0] arid;
  reg [7:0] arlen;
  reg [2:0] arsize;
  reg [1:0] arburst;
  wire rReady;
  wire rValid;
  wire [1:0] rresp;
  wire [31:0] rdata;
  wire rlast;
  wire [3:0] rid;

  always@(*)begin
	if(araddr >= 32'h20000000 || araddr <= 32'h0fffffff || araddr <= 32'h20000fff && araddr >= 32'h0fffffff)
	  TO_device();
	if(awaddr >= 32'h20000000 || awaddr <= 32'h0fffffff || awaddr <= 32'h20000fff && awaddr >= 32'h0fffffff)
	  TO_device();
  end

  assign awaddr = lsu_awaddr;
  assign awValid = lsu_awValid;
  assign lsu_awReady = awReady;
  assign wdata = lsu_wdata;
  assign wstrb = lsu_wstrb;
  assign wValid = lsu_wValid;
  assign lsu_wReady = wReady;
  assign lsu_bresp = bresp;
  assign lsu_bValid = bValid;
  assign bReady = lsu_bReady;
  assign awid = lsu_awid;
  assign awlen = lsu_awlen;
  assign awsize = lsu_awsize;
  assign awburst = lsu_awburst;
  assign wlast = lsu_wlast;
  assign lsu_bid = bid;

  reg arbiter_state, next_arbiter;
  parameter IFU = 0, LSU = 1;
  always@(*)begin
	case(arbiter_state)
	  IFU: next_arbiter = (ifu_arValid & lsu_arValid) | (ifu_arValid & lsu_arValid) ? LSU: IFU;
	  LSU: next_arbiter = (ifu_arValid & lsu_arValid) | (ifu_arValid & lsu_arValid) ? IFU: LSU;
	  default: next_arbiter = IFU;
	endcase
  end

  always@(posedge clk)begin
	arbiter_state <= next_arbiter;
  end

  always@(*)begin
	arValid = 0;
	araddr = 0;
	arid = 0;
	arlen = 0;
	arsize = 0;
	arburst = 0;
	if(ifu_arValid & lsu_arValid)begin
	  if(arbiter_state == IFU)begin
		arValid = ifu_arValid;
		araddr = ifu_araddr;
		arid = ifu_arid;
		arlen = ifu_arlen;
		arsize = ifu_arsize;
		arburst = ifu_arburst;
	  end
	  else begin
		arValid = lsu_arValid;
		araddr = lsu_araddr;
		arid = lsu_arid;
		arlen = lsu_arlen;
		arsize = lsu_arsize;
		arburst = lsu_arburst;
	  end
	end
	else if(ifu_arValid)begin
	  arValid = ifu_arValid;
	  araddr = ifu_araddr;
	  arid = ifu_arid;
	  arlen = ifu_arlen;
	  arsize = ifu_arsize;
	  arburst = ifu_arburst;
	end
	else if(lsu_arValid)begin
	  arValid = lsu_arValid;
	  araddr = lsu_araddr;
	  arid = lsu_arid;
	  arlen = lsu_arlen;
	  arsize = lsu_arsize;
	  arburst = lsu_arburst;
	end
  end

  assign ifu_rValid = rValid;
  assign lsu_rValid = rValid;
  assign ifu_arReady = arReady;
  assign lsu_arReady = arReady;
  assign rReady = ifu_rReady | lsu_rReady;
  assign ifu_rlast = rlast;
  assign lsu_rlast = rlast;
  assign ifu_rid = rid;
  assign lsu_rid = rid;

  always@(*)begin
	lsu_rdata = 32'b0;
	ifu_rdata = 32'b0;
	lsu_rresp = 2'b0;
	ifu_rresp = 2'b0;
	if(lsu_rReady)begin
	  lsu_rdata = rdata;
	  lsu_rresp = 2'b1;
	end
	else if(ifu_rReady)begin
	  ifu_rdata = rdata;
	  ifu_rresp = 2'b1;
	end
  end

  assign awReady = clint_awReady | io_master_awReady;
  assign wReady = clint_wReady | io_master_wReady;
  assign bresp = clint_bresp | io_master_bresp;
  assign bValid = clint_bValid | io_master_bValid;

  assign arReady = clint_arReady & io_master_arReady;
  assign rValid = clint_rValid | io_master_rValid;
  assign rresp = clint_rresp | io_master_rresp;

  assign io_master_rReady = rReady;
  assign clint_rReady = rReady;
  assign rdata = (io_master_rdata & {32{io_master_rValid}}) | (clint_rdata & {32{clint_rValid}});
  
  always@(*)begin
	io_master_awaddr = 0;
	io_master_awValid = 0;
	io_master_wdata = 0;
	io_master_wstrb = 0;
	io_master_wValid = 0;
	io_master_bReady = 0;
	io_master_arValid = 0;
	io_master_araddr = 0;
	io_master_arid = 0; 
	io_master_arlen = 0; 
	io_master_arsize = 0; 
	io_master_arburst = 0; 
	clint_awaddr = 0;
	clint_awValid = 0;
	clint_wdata = 0;
	clint_wstrb = 0;
	clint_wValid = 0;
	clint_bReady = 0;
	clint_arValid = 0;
	clint_araddr = 0;
	clint_arid = 0; 
	clint_arlen = 0; 
	clint_arsize = 0; 
	clint_arburst = 0; 
	if(araddr >= 32'h02000000 & araddr <= 32'h0200ffff)begin
	  clint_arValid = arValid;
	  clint_araddr = araddr;
	  clint_arid = arid;
	  clint_arlen = arlen;
	  clint_arsize = arsize;
	  clint_arburst = arburst;
	end
	else begin
	  io_master_arValid = arValid;
	  io_master_araddr = araddr;
	  io_master_arid = arid;
	  io_master_arlen = arlen;
	  io_master_arsize = arsize;
	  io_master_arburst = arburst;
	end
	if(awaddr >= 32'h02000000 & awaddr <= 32'h0200ffff)begin
	  clint_awaddr = awaddr;
	  clint_awValid = awValid;
	  clint_wdata = wdata ;
	  clint_wstrb = wstrb ;
	  clint_wValid = wValid;
	  clint_bReady = bReady;
	end
	else begin
	  io_master_awaddr = awaddr;
	  io_master_awValid = awValid;
	  io_master_wdata = wdata;
	  io_master_wstrb = wstrb;
	  io_master_wValid = wValid;
	  io_master_bReady = bReady;
	end
  end

endmodule
