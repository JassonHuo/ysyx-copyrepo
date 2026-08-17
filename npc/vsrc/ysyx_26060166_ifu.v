`include "global.vh"
module ysyx_26060166_ifu(
  input clk,
  input rst,
  input [31: 0] pc_in,
  input pc_en,

//  output [31: 0] inst_addr,

  output [31: 0] inst_out,
  output [31: 0] pc_sync_out,
  output valid,
  input ready,

  output [31: 0] pc_out,
  input done,

  input arReady,
  output arValid,
  output [31:0] araddr,
  output [3:0] arid,//
  output [7:0] arlen,//
  output [2:0] arsize,//
  output [1:0] arburst,//
  output rReady,
  input rValid,
  input [1:0] rresp,
  input [31:0] rdata,
  input rlast,//
  input [3:0] rid//
);

  assign arlen = 8'b0;
  assign arsize = `SIZE4;
  assign arburst = `BURST_FIXED;

  reg [2: 0] state, next_state;
  parameter IF_WAITARREADY = 0, IF_WAITRVALID = 1, IF_RREADY = 2, IF_RUN = 3;
  always@(*)begin
	if(rst)
	  next_state = IF_WAITARREADY;
	else begin
	  case(state)
		IF_WAITARREADY: next_state = arReady ? IF_WAITRVALID: IF_WAITARREADY;
		IF_WAITRVALID: next_state = rValid ? IF_RREADY: IF_WAITRVALID;
		IF_RREADY: next_state = IF_RUN;
		IF_RUN: next_state = done ? IF_WAITARREADY: IF_RUN;
		default: next_state = IF_WAITARREADY;
	  endcase
	end
  end

  always@(posedge clk)begin
	if(rst)
	  state <= IF_WAITARREADY;
	else
	  state <= next_state;
  end

  //lsfm
  reg [3: 0] lsfm;
  initial begin
	lsfm = 4'b1001;
  end
  always@(posedge clk)begin
	if(lsfm == 0)
	  lsfm <= 4'b1001;
	lsfm <= {lsfm[2: 0], lsfm[0] ^ lsfm[1] ^ lsfm[3]};
  end
  reg [3: 0] counter;
  //end

  assign valid = (state == IF_RUN);
  
  reg [31: 0] inst;
  assign arValid = rst ? 1'b0: (state == IF_WAITARREADY);
  assign rReady = (state == IF_RREADY);
  assign araddr = pc_out;

  always@(posedge clk)begin
	if(rValid & rReady)
	  inst <= rdata;
  end
  assign inst_out = inst;

  ysyx_26060166_pc pc0(
	.pc_en(done & pc_en),
	.pc_in(pc_in),
	.rst(rst),
	.clk(clk),
	.pc_out(pc_out),
	.pc_sync(pc_sync_out)
  );


endmodule
