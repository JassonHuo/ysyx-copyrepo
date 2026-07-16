`include "global.vh"
module exu(
  input [31: 0] pc_in,
  input [31: 0] pc_sync_in,

  input [31: 0] imm,
  input [31: 0] src1,
  input [31: 0] src2,
  input [3: 0] alu_op,
  input [1: 0] pc_src,
  input [1: 0] reg_src,
  input alu_src,
  input [3: 0] rd_addr,
  input wen,

  input mem_wen,
  input [7: 0] wmask,
  input valid,
  input [1: 0] width,

  output [31: 0] alu_out,
  output [31: 0] pc_sync_out,
  output [31: 0] pc_out,

  output [1: 0] pc_src_out,
  output [1: 0] reg_src_out,
  output [3: 0] rd_addr_out,
  output wen_out,

  output [31: 0] imm_out,

  output [31: 0] pc_plus_imm,

  output mem_wen_out,
  output [7: 0] wmask_out,
  output valid_out,
  output [31: 0] src2_out,
  output [1: 0] width_out
);

  assign pc_sync_out = pc_sync_in;
  assign pc_out = pc_in;
  assign pc_src_out = pc_src;
  assign reg_src_out = reg_src;
  assign rd_addr_out = rd_addr;
  assign wen_out = wen;

  assign imm_out = imm;

  assign pc_plus_imm = pc_in + imm;

  assign mem_wen_out = mem_wen;
  assign wmask_out = wmask; 
  assign valid_out = valid;

  assign src2_out = src2;

  assign width_out = width;

  wire zero;

  alu alu0(
	.x(src1),
	.y((alu_src == `ALU_IMM ? imm: src2)),
	.alu_op(alu_op),
	.z(alu_out),
	.zero(zero)
  );


endmodule
