module ysyx_26060166(
  input clock,
  input reset,
  input io_interrupt,
  input io_master_awReady,
  output io_master_awValid,
  output [31:0] io_master_awaddr,
  output [3:0] io_master_awid,
  output [7:0] io_master_awlen,
  output [2:0] io_master_awsize,
  output [1:0] io_master_awburst,
  input io_master_wReady,
  output io_master_wValid,
  output [31:0]io_master_wdata,
  output [3:0] io_master_wstrb,
  output io_master_wlast,
  output io_master_bReady,
  input io_master_bValid,
  input  [1:0] io_master_bresp,
  input  [3:0] io_master_bid ,
  input io_master_arReady,
  output io_master_arValid,
  output [31:0] io_master_araddr,
  output [3:0] io_master_arid,
  output [7:0] io_master_arlen,
  output [2:0] io_master_arsize,
  output [1:0] io_master_arburst,
  output io_master_rReady,
  input io_master_rValid,
  input [1:0] io_master_rresp,
  input [31:0] io_master_rdata,
  input io_master_rlast,
  input [3:0] io_master_rid
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
  wire [3: 0] arid_ifu_xbar;
  wire [7: 0] arlen_ifu_xbar;
  wire [2: 0] arsize_ifu_xbar;
  wire [1: 0] arburst_ifu_xbar;
  wire rlast_xbar_ifu;
  wire [3: 0] rid_xbar_ifu;

  wire arValid_ifu_xbar;
  wire arReady_xbar_ifu;
  wire [31: 0] araddr_ifu_xbar;
  wire rReady_ifu_xbar;
  wire rValid_xbar_ifu;
  wire [31: 0] rdata_xbar_ifu;
  wire [1: 0] rresp_xbar_ifu;
  wire arValid_lsu_xbar;
  wire arReady_xbar_lsu;
  wire [31: 0] araddr_lsu_xbar;
  wire rReady_lsu_xbar;
  wire rValid_xbar_lsu;
  wire [31: 0] rdata_xbar_lsu;
  wire [1: 0] rresp_xbar_lsu;
  wire [31: 0] awaddr_lsu_xbar;
  wire awValid_lsu_xbar;
  wire awReady_xbar_lsu;
  wire [31: 0] wdata_lsu_xbar;
  wire [3: 0] wstrb_lsu_xbar;
  wire wValid_lsu_xbar;
  wire wReady_xbar_lsu;
  wire [1: 0] bresp_xbar_lsu;
  wire bValid_xbar_lsu;
  wire bReady_lsu_xbar;
  wire [3: 0] rid_xbar_lsu;
  wire rlast_xbar_lsu;
  wire [1: 0] arburst_lsu_xbar;
  wire [2: 0] arsize_lsu_xbar;
  wire [7: 0] arlen_lsu_xbar;
  wire [3: 0] arid_lsu_xbar;
  wire [3: 0] bid_xbar_lsu;
  wire wlast_lsu_xbar;
  wire [1: 0] awburst_lsu_xbar;
  wire [2: 0] awsize_lsu_xbar;
  wire [7: 0] awlen_lsu_xbar;
  wire [3: 0] awid_lsu_xbar;

  wire arValid_xbar_clint;
  wire arReady_clint_xbar;
  wire [31: 0] araddr_xbar_clint;
  wire rReady_xbar_clint;
  wire rValid_clint_xbar;
  wire [31: 0] rdata_clint_xbar;
  wire [1: 0] rresp_clint_xbar;
  wire [31: 0] awaddr_xbar_clint;
  wire awValid_xbar_clint;
  wire awReady_clint_xbar;
  wire [31: 0] wdata_xbar_clint;
  wire [3: 0] wstrb_xbar_clint;
  wire wValid_xbar_clint;
  wire wReady_clint_xbar;
  wire [1: 0] bresp_clint_xbar;
  wire bValid_clint_xbar;
  wire bReady_xbar_clint;
  wire [3: 0] awid_clint_xbar;
  wire [7: 0] awlen_clint_xbar;
  wire [2: 0] awsize_clint_xbar;
  wire [1: 0] awburst_clint_xbar;
  wire wlast_clint_xbar;
  wire [3: 0] bid_xbar_clint;
  wire [3: 0] arid_clint_xbar;
  wire [7: 0] arlen_clint_xbar;
  wire [2: 0] arsize_clint_xbar;
  wire [1: 0] arburst_clint_xbar;
  wire rlast_xbar_clint;
  wire [3: 0] rid_xbar_clint;

  clint clint0(
	.clk(clock),
  	.arValid(arValid_xbar_clint),
  	.arReady(arReady_clint_xbar),
  	.araddr(araddr_xbar_clint),
	.rReady(rReady_xbar_clint),
	.rValid(rValid_clint_xbar),
  	.rdata(rdata_clint_xbar),
	.rresp(rresp_clint_xbar),
	.awaddr(awaddr_xbar_clint),
	.awValid(awValid_xbar_clint),
	.awReady(awReady_clint_xbar),
  	.wdata(wdata_xbar_clint),
  	.wstrb(wstrb_xbar_clint),
	.wValid(wValid_xbar_clint),
	.wReady(wReady_clint_xbar),
	.bresp(bresp_clint_xbar),
	.bValid(bValid_clint_xbar),
	.bReady(bReady_xbar_clint),

	.awid(awid_clint_xbar),
	.awlen(awlen_clint_xbar),
	.awsize(awsize_clint_xbar),
	.awburst(awburst_clint_xbar),
	.wlast(wlast_clint_xbar),
	.bid (bid_xbar_clint),
	.arid(arid_clint_xbar),
	.arlen(arlen_clint_xbar),
	.arsize(arsize_clint_xbar),
	.arburst(arburst_clint_xbar),
	.rlast(rlast_xbar_clint),
	.rid(rid_xbar_clint)
  );

  /*
  uart uart0(
	.clk(clock),
  	.arValid(arValid_xbar_uart),
  	.arReady(arReady_uart_xbar),
  	.araddr(araddr_xbar_uart),
	.rReady(rReady_xbar_uart),//
	.rValid(rValid_uart_xbar),//
  	.rdata(rdata_uart_xbar),
	.rresp(rresp_uart_xbar),
	.awaddr(awaddr_xbar_uart),
	.awValid(awValid_xbar_uart),
	.awReady(awReady_uart_xbar),
  	.wdata(wdata_xbar_uart),
  	.wstrb(wstrb_xbar_uart),
	.wValid(wValid_xbar_uart),
	.wReady(wReady_uart_xbar),
	.bresp(bresp_uart_xbar),
	.bValid(bValid_uart_xbar),
	.bReady(bReady_xbar_uart)
  );

  memory mem0(
	.clk(clock),
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
  */

  xbar xbar0(
	.clk(clock),
  	.ifu_arValid(arValid_ifu_xbar),
  	.ifu_arReady(arReady_xbar_ifu),
  	.ifu_araddr(araddr_ifu_xbar),
  	.ifu_rReady(rReady_ifu_xbar),
  	.ifu_rValid(rValid_xbar_ifu),
  	.ifu_rdata(rdata_xbar_ifu),
	.ifu_rresp(rresp_xbar_ifu),
	.ifu_arid(arid_ifu_xbar),
	.ifu_arlen(arlen_ifu_xbar),
	.ifu_arsize(arsize_ifu_xbar),
	.ifu_arburst(arburst_ifu_xbar),
	.ifu_rlast(rlast_xbar_ifu),
    .ifu_rid(rid_xbar_ifu),

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

	.lsu_awid(awid_lsu_xbar),
	.lsu_awlen(awlen_lsu_xbar),
	.lsu_awsize(awsize_lsu_xbar),
	.lsu_awburst(awburst_lsu_xbar),
	.lsu_wlast(wlast_lsu_xbar),
	.lsu_bid(bid_xbar_lsu),
	.lsu_arid(arid_lsu_xbar),
	.lsu_arlen(arlen_lsu_xbar),
	.lsu_arsize(arsize_lsu_xbar),
	.lsu_arburst(arburst_lsu_xbar),
	.lsu_rlast(rlast_xbar_lsu),
	.lsu_rid(rid_xbar_lsu),

	.io_master_awReady(io_master_awReady),
	.io_master_awValid(io_master_awValid),
	.io_master_awaddr(io_master_awaddr),
	.io_master_awid(io_master_awid),
	.io_master_awlen(io_master_awlen),
	.io_master_awsize(io_master_awsize),
	.io_master_awburst(io_master_awburst),
	.io_master_wReady(io_master_wReady),
	.io_master_wValid(io_master_wValid),
	.io_master_wdata(io_master_wdata),
	.io_master_wstrb(io_master_wstrb),
	.io_master_wlast(io_master_wlast),
	.io_master_bReady(io_master_bReady),
	.io_master_bValid(io_master_bValid),
	.io_master_bresp(io_master_bresp),
	.io_master_bid (io_master_bid ),
	.io_master_arReady(io_master_arReady),
	.io_master_arValid(io_master_arValid),
	.io_master_araddr(io_master_araddr),
	.io_master_arid(io_master_arid),
	.io_master_arlen(io_master_arlen),
	.io_master_arsize(io_master_arsize),
	.io_master_arburst(io_master_arburst),
	.io_master_rReady(io_master_rReady),
	.io_master_rValid(io_master_rValid),
	.io_master_rresp(io_master_rresp),
	.io_master_rdata(io_master_rdata),
	.io_master_rlast(io_master_rlast),
	.io_master_rid(io_master_rid),

  	.clint_arValid(arValid_xbar_clint),
  	.clint_arReady(arReady_clint_xbar),
  	.clint_araddr(araddr_xbar_clint),
	.clint_rReady(rReady_xbar_clint),
	.clint_rValid(rValid_clint_xbar),
  	.clint_rdata(rdata_clint_xbar),
	.clint_rresp(rresp_clint_xbar),
	.clint_awaddr(awaddr_xbar_clint),
	.clint_awValid(awValid_xbar_clint),
	.clint_awReady(awReady_clint_xbar),
  	.clint_wdata(wdata_xbar_clint),
  	.clint_wstrb(wstrb_xbar_clint),
	.clint_wValid(wValid_xbar_clint),
	.clint_wReady(wReady_clint_xbar),
	.clint_bresp(bresp_clint_xbar),
	.clint_bValid(bValid_clint_xbar),
	.clint_bReady(bReady_xbar_clint),

	.clint_awid(awid_clint_xbar),
	.clint_awlen(awlen_clint_xbar),
	.clint_awsize(awsize_clint_xbar),
	.clint_awburst(awburst_clint_xbar),
	.clint_wlast(wlast_clint_xbar),
	.clint_bid (bid_xbar_clint),
	.clint_arid(arid_clint_xbar),
	.clint_arlen(arlen_clint_xbar),
	.clint_arsize(arsize_clint_xbar),
	.clint_arburst(arburst_clint_xbar),
	.clint_rlast(rlast_xbar_clint),
	.clint_rid(rid_xbar_clint)
  );

  ifu ifu0(
	.clk(clock),
	.rst(reset),
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
  	.rdata(rdata_xbar_ifu),
	.rresp(rresp_xbar_ifu),

	.arid(arid_ifu_xbar),
	.arlen(arlen_ifu_xbar),
	.arsize(arsize_ifu_xbar),
	.arburst(arburst_ifu_xbar),
	.rlast(rlast_xbar_ifu),
	.rid(rid_xbar_ifu)
  );

  idu idu0(
	.clk(clock),
	.rst(reset),
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
	.clk(clock),
	.wdata(wdata_wbu_gpr),
	.waddr(waddr_wbu_gpr),
	.raddr1(raddr1_idu_gpr),
	.raddr2(raddr2_idu_gpr),
	.rdata1(rdata1_gpr_idu),
	.rdata2(rdata2_gpr_idu),
	.wen(wen_wb_gpr)
  );

  exu exu0(
	.clk(clock),
	.rst(reset),
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
	.clk(clock),
	.rst(reset),
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

	.awReady(awReady_xbar_lsu),
	.awValid(awValid_lsu_xbar),
	.awaddr(awaddr_lsu_xbar),
	.awid(awid_lsu_xbar),
	.awlen(awlen_lsu_xbar),
	.awsize(awsize_lsu_xbar),
	.awburst(awburst_lsu_xbar),
	.wReady(wReady_xbar_lsu),
	.wValid(wValid_lsu_xbar),
	.wdata(wdata_lsu_xbar),
	.wstrb(wstrb_lsu_xbar),
	.wlast(wlast_lsu_xbar),
	.bReady(bReady_lsu_xbar),
	.bValid(bValid_xbar_lsu),
	.bresp(bresp_xbar_lsu),
	.bid (bid_xbar_lsu),
	.arReady(arReady_xbar_lsu),
	.arValid(arValid_lsu_xbar),
	.araddr(araddr_lsu_xbar),
	.arid(arid_lsu_xbar),
	.arlen(arlen_lsu_xbar),
	.arsize(arsize_lsu_xbar),
	.arburst(arburst_lsu_xbar),
	.rReady(rReady_lsu_xbar),
	.rValid(rValid_xbar_lsu),
	.rresp(rresp_xbar_lsu),
	.lsu_rdata(rdata_xbar_lsu),
	.rlast(rlast_xbar_lsu),
	.rid(rid_xbar_lsu)
  );

  wbu wbu0(
	.clk(clock),
	.rst(reset),
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
	.clk(clock),
	.csr_en(csr_en_wbu_csr),
	.rst(reset),
	.csr_rdata_out(csr_data_csr_idu),
	
	.mepc_in(mepc_wbu_csr),
	.mcause_in(mcause_wbu_csr),
	.mtvec_out(mtvec_csr_wbu),
	.mepc_out(mepc_csr_wbu),
	.yield_csren(yield_csren_wbu_csr)
  );

endmodule
