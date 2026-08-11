import "DPI-C" function int pmem_read(input int raddr);
import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte wmask);

module lsu(
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

  output arValid,
  input arReady,
  output [31: 0] araddr,
  output rReady,
  input rValid,
  input [31: 0] lsu_rdata,
  input rresp,

  output [31: 0] awaddr,
  output awValid,
  input awReady,

  output [31: 0] wdata,
  output [3: 0] wstrb,
  output wValid,
  input wReady,

  input bresp,
  input bValid,
  output bReady
);

//  wire reqValid;
//  reg respValid;

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

  /*
  reg write_done;
  parameter AWIDLE = 0, AWWAIT_READY = 1, DONE = 2;
  reg [1: 0] awstate, next_awstate;
  always@(*)begin
	if(rst)
	  next_awstate = AWIDLE;
	else begin
	  case(awstate)
		AWIDLE: next_awstate = mem_wen ? AWWAIT_READY: AWIDLE;
		AWWAIT_READY: next_awstate = awReady ? DONE: AWWAIT_READY;
		DONE: next_awstate = write_done ? AWIDLE: DONE;
		default: next_awstate = AWIDLE;
	  endcase
	end
  end
  always@(posedge clk)begin
	if(rst)
	  awstate <= AWIDLE;
	else
	  awstate <= next_awstate;
  end
  assign awValid = (awstate == AWWAIT_READY);

  parameter WIDLE = 0, WWAIT_READY = 1;
  reg [1: 0] wstate, next_wstate;
  always@(*)begin
	if(rst)
	  next_wstate = WIDLE;
	else begin
	  case(wstate)
		WIDLE: next_wstate = mem_wen ? WWAIT_READY: WIDLE;
		WWAIT_READY: next_wstate = wReady ? DONE: WWAIT_READY;
		DONE: next_wstate = write_done ? WIDLE: DONE;
		default: next_wstate = WIDLE;
	  endcase
	end
  end
  always@(posedge clk)begin
	if(rst)
	  wstate <= WIDLE;
	else
	  wstate <= next_wstate;
  end
  assign wValid = (wstate == WWAIT_READY);
  */
  
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
		WAIT_READY: next_state = /*(wstate == DONE & awstate == DONE)*/(awReady & wReady) ? WAIT_BVALID: WAIT_READY;
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
//  assign write_done = (state == BREADY);
  assign araddr = alu;
  assign awaddr = alu;
  assign wdata = src2;
  assign wstrb = mask;
//  assign lsu_rdata = rdata;

  assign ready_pre = valid_pre;
  wire pre_succ = ready_pre & valid_pre;
//  assign valid_aft = pre_succ & ~next_state;
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
//  reg [31: 0] lsu_rdata;
  reg [31: 0] ifu_wdata;


 /*
  memory mem1(
	.clk(clk),
	.reqValid(reqValid),
	.reqReady(reqReady),
	.addr(alu),
	.wen(mem_wen),
	.wdata(src2),
	.mask(mask),
	.respValid(respValid),
	.respReady(respReady),
	.rdata(lsu_rdata)
  );
  */
//  wire reqReady, respReady;

  always@(*)begin
	if(mem_valid & valid_aft)begin
	  rdata = (lsu_rdata >> {alu[1: 0], 3'b0}) & (width == `MEM_WORD ? ~32'b0:
		(width == `MEM_HALF ? 32'hFFFF:
		(width == `MEM_BYTE ? 32'hFF: 32'b0)));
	  rdata = rdata | (width == `MEM_HALF ? {{16{is_signed & rdata[15]}}, 16'b0}:
		(width == `MEM_BYTE ? {{24{is_signed & rdata[7]}}, 8'b0}: 32'b0));
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
