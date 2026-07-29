`include "global.vh"
module wbu(
  input [31: 0] pc_sync,
  input [31: 0] pc_in,
  input [31: 0] alu,
  input [1: 0] pc_src,
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

  output csr_en,
  output reg [31: 0] csr_wdata_out,
  output [11: 0] csr_waddr,

  output reg pc_wen,
  output reg [31: 0] pc_dync_out,
  output [3: 0] rd_addr_out,
  output reg [31: 0] wdata_out,
  output wen_out
);

  assign rd_addr_out = rd_addr;
  assign wen_out = wen;
  assign csr_waddr = csr_addr;
  assign csr_en = |csr_type;

  always@(*)begin
	pc_wen = 1'b0;
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
	  default: begin
		pc_dync_out = pc_sync;
		pc_wen = 1'b0;
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
