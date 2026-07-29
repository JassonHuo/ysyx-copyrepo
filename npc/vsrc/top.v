module top(
  input clk,
  input rst,
  output [31: 0] pc,
  output [31: 0] a0
);

  wire pc_en_wb_pc;
  wire [31: 0] pc_wb_pc;
  wire [31: 0] pc_pc_ifu;
  wire [31: 0] pc_sync_pc_ifu;
  wire [31: 0] inst_ifu_idu;
  wire [31: 0] pc_sync_ifu_idu;
  wire [31: 0] pc_ifu_idu;

  wire [31: 0] imm_idu_exu;
  wire [31: 0] src1_idu_exu;
  wire [31: 0] src2_idu_exu;
  wire [3: 0] alu_op_idu_exu;
  wire [1: 0] pc_src_idu_exu;
  wire [2: 0] reg_src_idu_exu;
  wire alu_src_idu_exu;
  wire [3: 0] rd_addr_idu_exu;
  wire wen_idu_exu;

  wire [3: 0] raddr1_idu_gpr;
  wire [3: 0] raddr2_idu_gpr;
  wire [31: 0] rdata1_gpr_idu;
  wire [31: 0] rdata2_gpr_idu;

  wire [31: 0] pc_idu_exu;
  wire [31: 0] pc_sync_idu_exu;

  wire [31: 0] wdata_wbu_gpr;
  wire [3: 0] waddr_wbu_gpr;
  wire [3: 0] raddr1_wbu_gpr;
  wire [3: 0] raddr2_wbu_gpr;
  wire [31: 0] rdata_gpr_idu;
  wire wen_wb_gpr;

  wire [31: 0] alu_exu_lsu;
  wire [31: 0] pc_sync_exu_lsu;
  wire [31: 0] pc_exu_lsu;
  wire [1: 0] pc_src_exu_lsu;
  wire [2: 0] reg_src_exu_lsu;
  wire [3: 0] rd_addr_exu_lsu;
  wire wen_exu_lsu;
  wire [31: 0] imm_exu_lsu;

  wire [31: 0] pc_sync_lsu_wbu;
  wire [31: 0] pc_lsu_wbu;
  wire [31: 0] alu_lsu_wbu;
  wire [1: 0] pc_src_lsu_wbu;
  wire [2: 0] reg_src_lsu_wbu;
  wire [3: 0] rd_addr_lsu_wbu;
  wire wen_lsu_wbu;
  wire [31: 0] imm_lsu_wbu;

  wire [31: 0] pc_imm_exu_lsu;
  wire [31: 0] pc_imm_lsu_wbu;

  wire mem_wen_idu_exu;
  wire mem_wen_exu_lsu;
  wire [7: 0] wmask_idu_exu;
  wire [7: 0] wmask_exu_lsu;

  wire valid_idu_exu;
  wire valid_exu_lsu;
  wire [31: 0] rdata_lsu_wbu;
  wire [31: 0] src2_exu_lsu;

  wire [1: 0] width_idu_exu;
  wire [1: 0] width_exu_lsu;
  wire is_signed_idu_exu;
  wire is_branch_idu_exu;
  wire is_signed_exu_lsu;

  wire [31: 0] csr_data_csr_idu;
  wire [2: 0] csr_type_idu_exu;
  wire [11: 0] csr_addr_iduout;
  wire [31: 0] csr_imm_idu_exu;
  wire [31: 0] csr_data_idu_exu;
  
  wire [2: 0] csr_type_exu_lsu;
  wire [31: 0] csr_imm_exu_lsu;
  wire [31: 0] csr_data_exu_lsu;
  wire [11: 0] csr_addr_exu_lsu;
  wire [31: 0] src1_exu_lsu;

  wire [2: 0] csr_type_lsu_wbu;
  wire [31: 0] csr_imm_lsu_wbu;
  wire [31: 0] csr_data_lsu_wbu;
  wire [11: 0] csr_addr_lsu_wbu;
  wire [31: 0] src1_lsu_wbu;
  
  wire csr_en_wbu_csr;
  wire [31: 0] csr_wdata_wbu_csr;
  wire [11: 0] csr_waddr_wbu_csr;

  pc pc0(
	.pc_en(pc_en_wb_pc),
	.pc_in(pc_wb_pc),
	.rst(rst),
	.clk(clk),

	.pc_out(pc_pc_ifu),
	.pc_sync(pc_sync_pc_ifu)
  );

  ifu ifu0(
	.pc_in(pc_pc_ifu),
	.pc_sync_in(pc_sync_pc_ifu),
	.inst_addr(pc),
	.inst_out(inst_ifu_idu),
	.pc_sync_out(pc_sync_ifu_idu),
	.pc_out(pc_ifu_idu)
  );

  idu idu0(
	.inst_in(inst_ifu_idu),
	.pc_in(pc_ifu_idu),
	.pc_sync_in(pc_sync_ifu_idu),

	.imm(imm_idu_exu),
	.src1(src1_idu_exu),
	.src2(src2_idu_exu),
	.alu_op(alu_op_idu_exu),
	.pc_src(pc_src_idu_exu),
	.reg_src(reg_src_idu_exu),
	.alu_src(alu_src_idu_exu),
	.rd_addr(rd_addr_idu_exu),
	.wen(wen_idu_exu),
	.is_signed(is_signed_idu_exu),
	.is_branch(is_branch_idu_exu),

	.raddr1(raddr1_idu_gpr),
	.raddr2(raddr2_idu_gpr),
	.rdata1(rdata1_gpr_idu),
	.rdata2(rdata2_gpr_idu),

	.pc_out(pc_idu_exu),
	.pc_sync_out(pc_sync_idu_exu),

	.mem_wen(mem_wen_idu_exu),
	.wmask(wmask_idu_exu),
	.valid(valid_idu_exu),
	.width(width_idu_exu),

	.csr_data_in(csr_data_csr_idu),
	.csr_type(csr_type_idu_exu),
	.csr_addr(csr_addr_iduout),
	.csr_imm(csr_imm_idu_exu),
	.csr_data_out(csr_data_idu_exu)
  );

  gpr gpr0(
	.clk(clk),
	.wdata(wdata_wbu_gpr),
	.waddr(waddr_wbu_gpr),
	.raddr1(raddr1_idu_gpr),
	.raddr2(raddr2_idu_gpr),
	.rdata1(rdata1_gpr_idu),
	.rdata2(rdata2_gpr_idu),
	.wen(wen_wb_gpr),
	.a0(a0)
  );

  exu exu0(
	.pc_in(pc_idu_exu),
	.pc_sync_in(pc_sync_idu_exu),
	.imm(imm_idu_exu),
	.src1(src1_idu_exu),
	.src2(src2_idu_exu),
	.alu_op(alu_op_idu_exu),
	.pc_src(pc_src_idu_exu),
	.reg_src(reg_src_idu_exu),
	.alu_src(alu_src_idu_exu),
	.rd_addr(rd_addr_idu_exu),
	.wen(wen_idu_exu),
	.alu_out(alu_exu_lsu),
	.pc_sync_out(pc_sync_exu_lsu),
	.pc_out(pc_exu_lsu),
	.pc_src_out(pc_src_exu_lsu),
	.reg_src_out(reg_src_exu_lsu),
	.rd_addr_out(rd_addr_exu_lsu),
	.wen_out(wen_exu_lsu),
	.imm_out(imm_exu_lsu),
	.pc_plus_imm(pc_imm_exu_lsu),
	.mem_wen(mem_wen_idu_exu),
	.wmask(wmask_idu_exu),
	.mem_wen_out(mem_wen_exu_lsu),
	.wmask_out(wmask_exu_lsu),
	.valid(valid_idu_exu),
	.valid_out(valid_exu_lsu),
	.src2_out(src2_exu_lsu),
	.width(width_idu_exu),
	.width_out(width_exu_lsu),
	.is_signed(is_signed_idu_exu),
	.is_branch(is_branch_idu_exu),
	.is_signed_out(is_signed_exu_lsu),

	.csr_type(csr_type_idu_exu),
	.csr_imm(csr_imm_idu_exu),
	.csr_data_in(csr_data_idu_exu),
	.csr_addr(csr_addr_iduout),

	.csr_type_out(csr_type_exu_lsu),
	.csr_imm_out(csr_imm_exu_lsu),
	.csr_data_out(csr_data_exu_lsu),
	.csr_addr_out(csr_addr_exu_lsu),
	.src1_out(src1_exu_lsu)
  );

  lsu lsu0(
	.pc_sync_in(pc_sync_exu_lsu),
	.pc_in(pc_exu_lsu),
	.alu(alu_exu_lsu),
	.pc_src(pc_src_exu_lsu),
	.reg_src(reg_src_exu_lsu),
	.rd_addr(rd_addr_exu_lsu),
	.wen(wen_exu_lsu),
	.imm(imm_exu_lsu),
	.pc_plus_imm(pc_imm_exu_lsu),
	.pc_sync_out(pc_sync_lsu_wbu),
	.pc_out(pc_lsu_wbu),
	.alu_out(alu_lsu_wbu),
	.pc_src_out(pc_src_lsu_wbu),
	.reg_src_out(reg_src_lsu_wbu),
	.rd_addr_out(rd_addr_lsu_wbu),
	.wen_out(wen_lsu_wbu),
	.imm_out(imm_lsu_wbu),
	.pc_plus_imm_out(pc_imm_lsu_wbu),
	.wmask(wmask_exu_lsu),
	.mem_wen(mem_wen_exu_lsu),
	.valid(valid_exu_lsu),
	.rdata(rdata_lsu_wbu),
	.src2(src2_exu_lsu),
	.width(width_exu_lsu),
	.is_signed(is_signed_exu_lsu),

	.csr_type(csr_type_exu_lsu),
	.csr_imm(csr_imm_exu_lsu),
	.csr_data_in(csr_data_exu_lsu),
	.csr_addr(csr_addr_exu_lsu),
	.src1(src1_exu_lsu),

	.csr_type_out(csr_type_lsu_wbu),
	.csr_imm_out(csr_imm_lsu_wbu),
	.csr_data_out(csr_data_lsu_wbu),
	.csr_addr_out(csr_addr_lsu_wbu),
	.src1_out(src1_lsu_wbu)
  );

  wbu wbu0(
	.pc_sync(pc_sync_lsu_wbu),
	.pc_in(pc_lsu_wbu),
	.alu(alu_lsu_wbu),
	.pc_src(pc_src_lsu_wbu),
	.reg_src(reg_src_lsu_wbu),
	.rd_addr(rd_addr_lsu_wbu),
	.wen(wen_lsu_wbu),
	.imm(imm_lsu_wbu),
	.pc_plus_imm(pc_imm_lsu_wbu),
	.pc_wen(pc_en_wb_pc),
	.pc_dync_out(pc_wb_pc),
	.rd_addr_out(waddr_wbu_gpr),
	.wdata_out(wdata_wbu_gpr),
	.wen_out(wen_wb_gpr),
	.rdata(rdata_lsu_wbu),

	.csr_type(csr_type_lsu_wbu),
	.csr_imm(csr_imm_lsu_wbu),
	.csr_data_in(csr_data_lsu_wbu),
	.csr_addr(csr_addr_lsu_wbu),
	.src1(src1_lsu_wbu),
	.csr_en(csr_en_wbu_csr),
	.csr_wdata_out(csr_wdata_wbu_csr),
	.csr_waddr(csr_waddr_wbu_csr)
  );

  csr csr0(
	.csr_raddr(csr_addr_iduout),
	.csr_waddr(csr_waddr_wbu_csr),
	.csr_wdata(csr_wdata_wbu_csr),
	.clk(clk),
	.csr_en(csr_en_wbu_csr),
	.rst(rst),
	.csr_rdata_out(csr_data_csr_idu)
  );

endmodule
