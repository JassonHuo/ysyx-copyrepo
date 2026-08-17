import "DPI-C" function void TO_device();
module ysyx_26060166_clint(
  input clk,
  output  awReady,
  input awValid,
  input [31:0] awaddr,
  input [3:0] awid,
  input [7:0] awlen,
  input [2:0] awsize,
  input [1:0] awburst,
  output wReady,
  input wValid,
  input [31:0]wdata,
  input [3:0] wstrb,
  input wlast,
  input bReady,
  output bValid,
  output  [1:0] bresp,
  output  [3:0] bid ,
  output arReady,
  input arValid,
  input [31:0] araddr,
  input [3:0] arid,
  input [7:0] arlen,
  input [2:0] arsize,
  input [1:0] arburst,
  input rReady,
  output rValid,
  output [1:0] rresp,
  output reg [31:0] rdata,
  output rlast,
  output [3:0] rid
);

  reg [31: 0] mtime, mtimeh;

  reg state, next_state;
  parameter IDLE = 0, WAIT_RREADY = 1;
  always@(*)begin
	case(state)
	  IDLE: next_state = arValid ? WAIT_RREADY: IDLE;
	  WAIT_RREADY: next_state = rReady ? IDLE: WAIT_RREADY;
	  default: next_state = IDLE;
	endcase
  end

  reg [31: 0] addr;

  always@(posedge clk)begin
	state <= next_state;
	mtime <= mtime + 1;
	mtimeh <= (mtime == 32'hffffffff) ? mtimeh + 1: mtimeh;
	if(arValid & arReady)begin
	  addr <= araddr;
	  `ifdef VERILATOR
		TO_device();
	  `endif
	end
  end

  assign arReady = ~state;
  assign rValid = state;
  always@(*)begin
	if(addr == 32'h02000000)
	  rdata = mtime;
	else if(addr == 32'h02000004)
	  rdata = mtimeh;
	else
	  rdata = 32'b0;
  end

endmodule
