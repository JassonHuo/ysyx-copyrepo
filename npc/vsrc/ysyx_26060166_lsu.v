`ifdef VERILATOR
import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte wmask);
`endif

module ysyx_26060166_lsu(
  input clk,
  input rst,
  input [31: 0] pc_sync_in,
  input [31: 0] pc_in,

  input [31: 0] alu,
  input [2: 0] pc_src,
  input [2: 0] reg_src,
  input [3: 0] rd_addr,
  input wen,

  input [31: 0] imm,

  input [31: 0] pc_plus_imm,

  input mem_wen,
  input [7: 0] wmask,
  input mem_valid,
  input [31: 0] src2,

  input [1: 0] width,
  input is_signed,

  
  input [2: 0] csr_type,
  input [31: 0] csr_imm,
  input [31: 0] csr_data_in,
  input [11: 0] csr_addr,
  input [31: 0] src1,

  output [2: 0] csr_type_out,
  output [31: 0] csr_imm_out,
  output [31: 0] csr_data_out,
  output [11: 0] csr_addr_out,
  output [31: 0] src1_out,

  output [31: 0] pc_sync_out,
  output [31: 0] pc_out,
  output [31: 0] alu_out,
  output [2: 0] pc_src_out,
  output [2: 0] reg_src_out,
  output [3: 0] rd_addr_out,
  output wen_out,

  output [31: 0] imm_out,

  output [31: 0] pc_plus_imm_out,
  output reg [31: 0] rdata,

  input valid_pre,
  output ready_pre,
  output valid_aft,
  input ready_aft,

  input  awReady,
  output awValid,
  output [31:0] awaddr,
  output [3:0] awid,
  output [7:0] awlen,
  output [2:0] awsize,
  output [1:0] awburst,
  input wReady,
  output wValid,
  output [31:0]wdata,
  output [3:0] wstrb,
  output wlast,
  output bReady,
  input bValid,
  input  [1:0] bresp,
  input  [3:0] bid ,
  input arReady,
  output arValid,
  output [31:0] araddr,
  output [3:0] arid,
  output [7:0] arlen,
  output [2:0] arsize,
  output [1:0] arburst,
  output rReady,
  input rValid,
  input [1:0] rresp,
  input [31:0] lsu_rdata,
  input rlast,
  input [3:0] rid
);

  //lsfm
  reg [7: 0] lsfm;
  reg [7: 0] counter;
  initial begin
	lsfm = 8'b00101001;
  end
  
  always@(posedge clk)begin
	lsfm <= {lsfm[6: 0], lsfm[0] ^ lsfm[3] ^ lsfm[7] ^ lsfm[2]};
  end
  //end

  parameter IDLE = 0, WAIT_ARREADY = 1, WAIT_RVALID = 2, RREADY = 3;
  parameter WAIT_READY = 4, WAIT_BVALID = 5, BREADY = 6;
  reg [2: 0] state, next_state;
  always@(*)begin
	if(rst)
	  next_state = IDLE;
	else begin
	  case(state)
		IDLE: next_state = mem_valid ? (mem_wen ? WAIT_READY: WAIT_ARREADY): IDLE;
		WAIT_ARREADY: next_state = arReady ? WAIT_RVALID: WAIT_ARREADY;
		WAIT_RVALID: next_state = rValid ? RREADY: WAIT_RVALID;
		RREADY: next_state = IDLE;
		WAIT_READY: next_state = (awReady & wReady) ? WAIT_BVALID: WAIT_READY;
		WAIT_BVALID: next_state = bValid ? BREADY: WAIT_BVALID;
		BREADY: next_state = IDLE;
		default: next_state = IDLE;
	  endcase
	end
  end
  always@(posedge clk)begin
	if(rst)
	  state <= IDLE;
	else
	  state <= next_state;
  end
  assign awValid = (state == WAIT_READY);
  assign wValid = awValid;

  assign arValid = (state == WAIT_ARREADY);
  assign rReady = (state == RREADY);
  assign bReady = (state == BREADY);
  assign araddr = alu;
  assign awaddr = alu;
  assign wdata = src2;
  assign wstrb = mask;
  assign awlen = 8'b0;
  assign awsize = {1'b0, width};
  assign awburst = `BURST_FIXED;
  assign arlen = 8'b0;
  assign arsize = {1'b0, width};
  assign arburst = `BURST_FIXED;
  assign wlast = (state == WAIT_READY);

  assign ready_pre = valid_pre;
  wire pre_succ = ready_pre & valid_pre;
  assign valid_aft = pre_succ & (~mem_valid | (mem_valid & (state == BREADY | state == RREADY)));

  assign pc_sync_out = pc_sync_in;
  assign pc_out = pc_in;
  assign alu_out = alu;
  assign pc_src_out = pc_src;
  assign reg_src_out = reg_src;
  assign rd_addr_out = rd_addr;
  assign wen_out = wen; 
  assign imm_out = imm;

  assign pc_plus_imm_out = pc_plus_imm;

  assign csr_type_out = csr_type;
  assign csr_imm_out = csr_imm;
  assign csr_data_out = csr_data_in;
  assign csr_addr_out = csr_addr;

  assign src1_out = src1;

  wire [3: 0] mask = (width == `MEM_WORD ? 4'b1111:
	(width == `MEM_HALF ? 4'b11 << alu[1: 0]:
	(width == `MEM_BYTE ? 4'b1  << alu[1: 0] : 4'b0)));
  reg [31: 0] ifu_wdata;

  always@(*)begin
	if(mem_valid & valid_aft)begin
	  /*
	  rdata = (lsu_rdata >> {alu[1: 0], 3'b0}) & (width == `MEM_WORD ? ~32'b0:
		(width == `MEM_HALF ? 32'hFFFF:
		(width == `MEM_BYTE ? 32'hFF: 32'b0)));
	  rdata = rdata | (width == `MEM_HALF ? {{16{is_signed & rdata[15]}}, 16'b0}:
		(width == `MEM_BYTE ? {{24{is_signed & rdata[7]}}, 8'b0}: 32'b0));
	  */
	  rdata = lsu_rdata;
	  if(mem_wen)begin
		ifu_wdata = src2;
	  end
	  else begin
		ifu_wdata = 32'b0;
	  end
	end
	else begin
	  rdata = 32'b0;
	  ifu_wdata = 32'b0;
	end
  end

endmodule
