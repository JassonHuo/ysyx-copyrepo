module top(
  input clk,
  input rst,
  output done
);

  wire pc_en_wb_ifu;
  wire [31: 0] pc_wb_ifu;
  wire [31: 0] pc_pc_ifu;
  wire [31: 0] pc_sync_pc_ifu;
  wire [31: 0] inst_ifu_idu;
  wire [31: 0] pc_sync_ifu_idu;
  wire [31: 0] pc_ifu_idu;

  wire [31: 0] imm_idu_exu;
  wire [31: 0] src1_idu_exu;
  wire [31: 0] src2_idu_exu;
  wire [3: 0] alu_op_idu_exu;
  wire [2: 0] pc_src_idu_exu;
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
  wire [2: 0] pc_src_exu_lsu;
  wire [2: 0] reg_src_exu_lsu;
  wire [3: 0] rd_addr_exu_lsu;
  wire wen_exu_lsu;
  wire [31: 0] imm_exu_lsu;

  wire [31: 0] pc_sync_lsu_wbu;
  wire [31: 0] pc_lsu_wbu;
  wire [31: 0] alu_lsu_wbu;
  wire [2: 0] pc_src_lsu_wbu;
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

  wire mem_valid_idu_exu;
  wire mem_valid_exu_lsu;
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
  wire [31: 0] mepc_wbu_csr;
  wire [31: 0] mcause_wbu_csr;
  wire [31: 0] mtvec_csr_wbu;
  wire [31: 0] mepc_csr_wbu;

  wire yield_csren_wbu_csr;
  wire valid_ifu_idu;
  wire valid_idu_exu;
  wire valid_exu_lsu;
  wire valid_lsu_wbu;
  wire ready_idu_ifu;
  wire ready_exu_idu;
  wire ready_lsu_exu;
  wire ready_wbu_lsu;
  wire done_wbu_ifu;
  assign done = done_wbu_ifu;

  /*
  wire reqValid_ifu_xbar;
  wire reqReady_xbar_ifu;
  wire [31: 0] addr_ifu_xbar;
  wire respReady_ifu_xbar;
  wire respValid_xbar_ifu;
  wire [31: 0] rdata_xbar_ifu;

  wire reqValid_lsu_xbar;
  wire reqReady_xbar_lsu;
  wire [31: 0] addr_lsu_xbar;
  wire [31: 0] wdata_lsu_xbar;
  wire [3: 0] mask_lsu_xbar;
  wire respReady_lsu_xbar;
  wire respValid_xbar_lsu;
  wire [31: 0] rdata_xbar_lsu;

  wire reqValid_xbar_mem;
  wire reqReady_mem_xbar;
  wire [31: 0] addr_xbar_mem;
  wire [31: 0] wdata_xbar_mem;
  wire [3: 0] mask_xbar_mem;
  wire respReady_xbar_mem;
  wire respValid_mem_xbar;
  wire [31: 0] rdata_mem_xbar;
  */

  wire arValid_xbar_mem;
  wire arReady_mem_xbar;
  wire [31: 0] araddr_xbar_mem;
  wire [31: 0] rdata_mem_xbar;
  wire rresp_mem_xbar;
  wire rValid_mem_xbar;
  wire rReady_xbar_mem;
  wire [31: 0] awaddr_xbar_mem;
  wire awValid_xbar_mem;
  wire awReady_mem_xbar;
  wire [31: 0] wdata_xbar_mem;
  wire [3: 0] wstrb_xbar_mem;
  wire wValid_xbar_mem;
  wire wReady_mem_xbar;
  wire bresp_mem_xbar;
  wire bValid_mem_xbar;
  wire bReady_xbar_mem;

  wire arValid_ifu_xbar;
  wire arReady_xbar_ifu;
  wire [31: 0] araddr_ifu_xbar;
  wire rReady_ifu_xbar;
  wire rValid_xbar_ifu;
  wire [31: 0] rdata_xbar_ifu;
  wire rresp_xbar_ifu;
  wire arValid_lsu_xbar;
  wire arReady_xbar_lsu;
  wire [31: 0] araddr_lsu_xbar;
  wire rReady_lsu_xbar;
  wire rValid_xbar_lsu;
  wire [31: 0] rdata_xbar_lsu;
  wire rresp_xbar_lsu;
  wire [31: 0] awaddr_lsu_xbar;
  wire awValid_lsu_xbar;
  wire awReady_xbar_lsu;
  wire [31: 0] wdata_lsu_xbar;
  wire [3: 0] wstrb_lsu_xbar;
  wire wValid_lsu_xbar;
  wire wReady_xbar_lsu;
  wire bresp_xbar_lsu;
  wire bValid_xbar_lsu;
  wire bReady_lsu_xbar;

  memory mem0(
	.clk(clk),
	.arValid(arValid_xbar_mem),
	.arReady(arReady_mem_xbar),
	.araddr(araddr_xbar_mem),
	.rdata(rdata_mem_xbar),
	.rresp(rresp_mem_xbar),
	.rValid(rValid_mem_xbar),
	.rReady(rReady_xbar_mem),
	.awaddr(awaddr_xbar_mem),
	.awValid(awValid_xbar_mem),
	.awReady(awReady_mem_xbar),
	.wdata(wdata_xbar_mem),
	.wstrb(wstrb_xbar_mem),
	.wValid(wValid_xbar_mem),
	.wReady(wReady_mem_xbar),
	.bresp(bresp_mem_xbar),
	.bValid(bValid_mem_xbar),
	.bReady(bReady_xbar_mem)
  );

  xbar xbar0(
  	.ifu_arValid(arValid_ifu_xbar),
  	.ifu_arReady(arReady_xbar_ifu),
  	.ifu_araddr(araddr_ifu_xbar),
  	.ifu_rReady(rReady_ifu_xbar),
  	.ifu_rValid(rValid_xbar_ifu),
  	.ifu_rdata(rdata_xbar_ifu),
	.ifu_rresp(rresp_xbar_ifu),

  	.lsu_arValid(arValid_lsu_xbar),
  	.lsu_arReady(arReady_xbar_lsu),
  	.lsu_araddr(araddr_lsu_xbar),
	.lsu_rReady(rReady_lsu_xbar),
	.lsu_rValid(rValid_xbar_lsu),
	.lsu_rdata(rdata_xbar_lsu),
	.lsu_rresp(rresp_xbar_lsu),
	.lsu_awaddr(awaddr_lsu_xbar),
	.lsu_awValid(awValid_lsu_xbar),
	.lsu_awReady(awReady_xbar_lsu),
	.lsu_wdata(wdata_lsu_xbar),
	.lsu_wstrb(wstrb_lsu_xbar),
	.lsu_wValid(wValid_lsu_xbar),
	.lsu_wReady(wReady_xbar_lsu),
	.lsu_bresp(bresp_xbar_lsu),
	.lsu_bValid(bValid_xbar_lsu),
	.lsu_bReady(bReady_lsu_xbar),

  	.arValid(arValid_xbar_mem),
  	.arReady(arReady_mem_xbar),
  	.araddr(araddr_xbar_mem),
	.rReady(rReady_xbar_mem),//
	.rValid(rValid_mem_xbar),//
  	.rdata(rdata_mem_xbar),
	.rresp(rresp_mem_xbar),
	.awaddr(awaddr_xbar_mem),
	.awValid(awValid_xbar_mem),
	.awReady(awReady_mem_xbar),
  	.wdata(wdata_xbar_mem),
  	.wstrb(wstrb_xbar_mem),
	.wValid(wValid_xbar_mem),
	.wReady(wReady_mem_xbar),
	.bresp(bresp_mem_xbar),
	.bValid(bValid_mem_xbar),
	.bReady(bReady_xbar_mem)
  );

  ifu ifu0(
	.clk(clk),
	.rst(rst),
	.pc_in(pc_wb_ifu),
	.pc_en(pc_en_wb_ifu),
	.inst_out(inst_ifu_idu),
	.valid(valid_ifu_idu),
	.ready(ready_idu_ifu),
	.pc_sync_out(pc_sync_ifu_idu),
	.pc_out(pc_ifu_idu),
	.done(done_wbu_ifu),

  	.arValid(arValid_ifu_xbar),
  	.arReady(arReady_xbar_ifu),
  	.araddr(araddr_ifu_xbar),
  	.rReady(rReady_ifu_xbar),
  	.rValid(rValid_xbar_ifu),
  	.inst_in(rdata_xbar_ifu)
  );

  idu idu0(
	.clk(clk),
	.rst(rst),
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
	.mem_valid(mem_valid_idu_exu),
	.width(width_idu_exu),

	.csr_data_in(csr_data_csr_idu),
	.csr_type(csr_type_idu_exu),
	.csr_addr(csr_addr_iduout),
	.csr_imm(csr_imm_idu_exu),
	.csr_data_out(csr_data_idu_exu),
	.valid_pre(valid_ifu_idu),
	.ready_pre(ready_idu_ifu),
	.valid_aft(valid_idu_exu),
	.ready_aft(ready_exu_idu)
  );

  gpr gpr0(
	.clk(clk),
	.wdata(wdata_wbu_gpr),
	.waddr(waddr_wbu_gpr),
	.raddr1(raddr1_idu_gpr),
	.raddr2(raddr2_idu_gpr),
	.rdata1(rdata1_gpr_idu),
	.rdata2(rdata2_gpr_idu),
	.wen(wen_wb_gpr)
  );

  exu exu0(
	.clk(clk),
	.rst(rst),
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
	.mem_valid(mem_valid_idu_exu),
	.mem_valid_out(mem_valid_exu_lsu),
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
	.src1_out(src1_exu_lsu),

	.valid_pre(valid_idu_exu),
	.ready_pre(ready_exu_idu),
	.valid_aft(valid_exu_lsu),
	.ready_aft(ready_lsu_exu)
  );

  lsu lsu0(
	.clk(clk),
	.rst(rst),
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
	.mem_valid(mem_valid_exu_lsu),
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
	.src1_out(src1_lsu_wbu),

	.valid_pre(valid_exu_lsu),
	.ready_pre(ready_lsu_exu),
	.valid_aft(valid_lsu_wbu),
	.ready_aft(ready_wbu_lsu),

  	.arValid(arValid_lsu_xbar),
  	.arReady(arReady_xbar_lsu),
  	.araddr(araddr_lsu_xbar),
	.rReady(rReady_lsu_xbar),//
	.rValid(rValid_xbar_lsu),//
  	.lsu_rdata(rdata_xbar_lsu),
	.rresp(rresp_xbar_lsu),
	.awaddr(awaddr_lsu_xbar),
	.awValid(awValid_lsu_xbar),
	.awReady(awReady_xbar_lsu),
  	.wdata(wdata_lsu_xbar),
  	.wstrb(wstrb_lsu_xbar),
	.wValid(wValid_lsu_xbar),
	.wReady(wReady_xbar_lsu),
	.bresp(bresp_xbar_lsu),
	.bValid(bValid_xbar_lsu),
	.bReady(bReady_lsu_xbar)
  );

  wbu wbu0(
	.clk(clk),
	.rst(rst),
	.pc_sync(pc_sync_lsu_wbu),
	.pc_in(pc_lsu_wbu),
	.alu(alu_lsu_wbu),
	.pc_src(pc_src_lsu_wbu),
	.reg_src(reg_src_lsu_wbu),
	.rd_addr(rd_addr_lsu_wbu),
	.wen(wen_lsu_wbu),
	.imm(imm_lsu_wbu),
	.pc_plus_imm(pc_imm_lsu_wbu),
	.pc_wen(pc_en_wb_ifu),
	.done(done_wbu_ifu),
	.pc_dync_out(pc_wb_ifu),
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
	.csr_waddr(csr_waddr_wbu_csr),

	.mepc_out(mepc_wbu_csr),
	.mcause_out(mcause_wbu_csr),
	.mtvec_in(mtvec_csr_wbu),
	.mepc_in(mepc_csr_wbu),
	.yield_csren(yield_csren_wbu_csr),

	.valid_pre(valid_lsu_wbu),
	.ready_pre(ready_wbu_lsu)
//	.valid_aft(valid_lsu_wbu),
//	.ready_aft(ready_wbu_lsu)
  );

  csr csr0(
	.csr_raddr(csr_addr_iduout),
	.csr_waddr(csr_waddr_wbu_csr),
	.csr_wdata(csr_wdata_wbu_csr),
	.clk(clk),
	.csr_en(csr_en_wbu_csr),
	.rst(rst),
	.csr_rdata_out(csr_data_csr_idu),
	
	.mepc_in(mepc_wbu_csr),
	.mcause_in(mcause_wbu_csr),
	.mtvec_out(mtvec_csr_wbu),
	.mepc_out(mepc_csr_wbu),
	.yield_csren(yield_csren_wbu_csr)
  );

endmodule
