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
  output bReady,
);

  reg [2: 0] state, next_state;
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

  parameter LS_IDLE = 0, LS_WAIT_ARREADY = 1, LS_WAIT_RVALID = 2, LS_RREADY = 3;
  parameter LS_WAIT_AWREADY = 4, LS_WAIT_WREADY = 5, LS_WAIT_BVALID = 6, LS_BREADY = 7;
  always@(*)begin
	if(rst)
	  next_state = LS_IDLE;
	else begin
	  case(state)
		/*
		LS_IDLE: next_state = mem_valid ? LS_WAITREQREADY: LS_IDLE;
		LS_WAITREQREADY: next_state = reqReady ? LS_WAITRESP: LS_WAITREQREADY;
		LS_WAITRESP: next_state = respValid & (counter == 0) ? LS_RESPREADY: LS_WAITRESP;
		LS_RESPREADY: next_state = LS_IDLE;
		*/
		LS_IDLE: next_state = mem_valid ? (mem_wen ? LS_WAIT_AWREADY: LS_WAIT_ARREADY): LS_IDLE;
		LS_WAIT_ARREADY: next_state = arReady ? LS_WAIT_RVALID: LS_WAIT_ARREADY;
		LS_WAIT_RVALID: next_state = rValid ? LS_READY: LS_WAIT_RVALID;
		LS_READY: next_state = LS_IDLE;
		LS_WAIT_AWREADY: next_state = awReady ? LS_WAIT_WREADY: LS_WAIT_AWREADY;
		LS_WAIT_WREADY: next_state = wReady ? LS_WAIT_BVALID: LS_WAIT_WREADY;
		LS_WAIT_BVALID: next_state = bValid ? LS_BREADY: LS_WAIT_BVALID;
		
		default: next_state = LS_IDLE;
	  endcase
	end
  end
  assign reqValid = (state == LS_WAITREQREADY);
  assign respReady = (state == LS_RESPREADY);
  assign addr = alu;
  assign mem_wen_out = mem_wen;
  assign wdata = src2;
  assign mask_out = mask;
//  assign lsu_rdata = rdata;

  always@(posedge clk)begin
	if(rst)
	  state <= LS_IDLE;
	else begin
	  if(valid_pre)
		state <= next_state;
	  else
		state <= state;
	end
//	counter = (counter == 0 ? lsfm: counter - 1);
	counter <= 0;
  end

  assign ready_pre = valid_pre;
  wire pre_succ = ready_pre & valid_pre;
//  assign valid_aft = pre_succ & ~next_state;
  assign valid_aft = pre_succ & (~mem_valid | (mem_valid & (state == LS_RESPREADY)));

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
