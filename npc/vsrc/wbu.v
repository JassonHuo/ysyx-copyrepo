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

  input [31: 0] pc_plus_imm,
  input [31: 0] rdata,

  output reg pc_wen,
  output reg [31: 0] pc_dync_out,
  output [3: 0] rd_addr_out,
  output reg [31: 0] wdata_out,
  output wen_out
);

  assign rd_addr_out = rd_addr;
  assign wen_out = wen;

  always@(*)begin
	pc_wen = 1'b0;
	case(pc_src)
	  `PC_NEXT: begin
		pc_dync_out = pc_sync;
		pc_wen = 1'b0;
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
	  default:begin
		wdata_out = 32'b0;
	  end
	endcase
  end

endmodule
