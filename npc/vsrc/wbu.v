`include "global.vh"
module wbu(
  input [31: 0] pc_sync,
  input [31: 0] pc_in,
  input [31: 0] alu,
  input [2: 0] pc_src,
  input [2: 0] reg_src,
  input [3: 0] rd_addr,
  input wen,

  input [31: 0] imm,
  input [31: 0] src1,

  input [31: 0] pc_plus_imm,
  input [31: 0] rdata,

  input [2: 0] csr_type,
  input [31: 0] csr_imm,
  input [31: 0] csr_data_in,
  input [11: 0] csr_addr,

  output reg csr_en,
  output reg [31: 0] csr_wdata_out,
  output [11: 0] csr_waddr,

  output reg pc_wen,
  output reg [31: 0] pc_dync_out,
  output [3: 0] rd_addr_out,
  output reg [31: 0] wdata_out,
  output wen_out,

  output [31: 0] mepc_out,
  output [31: 0] mcause_out,
  input [31: 0] mtvec_in,
  input [31: 0] mepc_in,

  output yield_csren
);

  assign rd_addr_out = rd_addr;
  assign wen_out = wen;
  assign csr_waddr = csr_addr;

  always@(*)begin
	pc_wen = 1'b0;
	csr_en = |csr_type;
	yield_csren = 1'b1;
	if(csr_en)
	  $display("in wb csrdata: %08x", alu);
	case(pc_src)
	  `PC_NEXT: begin
		pc_dync_out = pc_sync;
		pc_wen = 1'b1;
	  end
	  `PC_JALR: begin
		pc_dync_out = alu;
		pc_wen = 1'b1;
	  end
	  `PC_JAL:begin
		pc_dync_out = pc_plus_imm;
		pc_wen = 1'b1;
	  end
	  `PC_BRANCH:begin
		pc_dync_out = (alu == 32'b1 ? pc_plus_imm: pc_sync);
		pc_wen = 1'b1;
	  end
	  `PC_MTVEC:begin
		pc_dync_out = mtvec_in;
		mepc_out = pc_in;
		mcause_out = 32'd11;
		pc_wen = 1'b1;
		yield_csren = 1'b1;
		csr_waddr = 12'b0;
	  end
	  `PC_MEPC:begin
		pc_dync_out = mepc_in;
		pc_wen = 1'b1;
		csr_waddr = 12'b0;
	  end
	  default: begin
		pc_dync_out = pc_sync;
		pc_wen = 1'b1;
	  end
	endcase

	case(reg_src)
	  `RD_ALU: begin
		wdata_out = alu;
	  end
	  `RD_PC: begin
		wdata_out = pc_sync;
	  end
	  `RD_IMM: begin
		wdata_out = imm;
	  end
	  `RD_MEM: begin
		wdata_out = rdata;
	  end
	  `RD_AUIPC:begin
		wdata_out = pc_plus_imm;
	  end
	  `RD_CSR:begin
		wdata_out = csr_data_in;
	  end
	  default:begin
		wdata_out = 32'b0;
	  end
	endcase

	case(csr_type)
	  `CSR_RW: begin
		csr_wdata_out = src1;
	  end
	  `CSR_RWI: begin
		csr_wdata_out = csr_imm;
	  end
	  `CSR_RC: begin
		csr_wdata_out = alu;
	  end
	  `CSR_RCI: begin
		csr_wdata_out = alu;
	  end
	  `CSR_RS: begin
		csr_wdata_out = alu;
	  end
	  `CSR_RSI: begin
		csr_wdata_out = alu;
	  end
	endcase
  end

endmodule
