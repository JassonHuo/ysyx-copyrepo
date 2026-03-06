module top(
  input clk,
  input rst
);

  wire [3: 0] pc;
  wire pc_en;
  wire reg_wen;
  wire [3: 0] pc_addr;
  wire [3: 0] pc_out;
  wire [3: 0] rom_addr;
  wire [7: 0] inst_code;
  wire [7: 0] rom_code;
  wire [1: 0] opcode;
  wire [1: 0] rs1;
  wire [1: 0] rs2;
  wire [1: 0] rd;
  wire [3: 0] imm;
  wire [3: 0] addr;
  wire [7: 0] rdata_in1;
  wire [7: 0] rdata_in2;
  wire wen;
  wire [7: 0] wdata;
  wire [1: 0] waddr;
  wire [1: 0] raddr1;
  wire [1: 0] raddr2;

  pc_reg pc0(
	.clk(clk),
	.rst(rst),
	.pc_en(pc_en),
	.pc_addr_in(pc_addr),
	.pc_out(pc_out)
  );

  inst_fetch ifet(
	.pc_in(pc),
	.rom_addr_out(rom_addr),
	.rom_in(rom_code),
	.inst_out(inst_code)
  );
  
  rom rom1(
	.inst_addr_in(rom_addr),
	.inst_code_out(rom_code)
  );

  inst_deco id(
	.inst_in(inst_code),
	.opcode(opcode),
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	.imm(imm),
	.addr(addr)
  );

  ex ex1(
	.opcode(opcode),
	.rd(rd),
	.rs1(rs1),
	.rs2(rs2),
	.imm(imm),
	.addr(addr),
	.rdata_in1(rdata_in1),
	.rdata_in2(rdata_in2),
	.wen(wen),
	.wdata(wdata),
	.waddr(waddr),
	.raddr1(raddr1),
	.raddr2(raddr2),
	.pc_en(pc_en),
	.pc_addr_out(pc_addr)
  );

  gpr_reg gpr(
	.raddr1_in(raddr1),
	.raddr2_in(raddr2),
	.rdata1_out(rdata_in1),
	.rdata2_out(rdata_in2),
	.waddr(waddr),
	.wdata(wdata),
	.wen(wen),
	.clk(clk)
  );

endmodule
