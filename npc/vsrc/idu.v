`include "global.vh"
import "DPI-C" function void ebreak();
module idu(
  input [31: 0] inst_in,
  input [31: 0] pc_in,
  input [31: 0] pc_sync_in,

  output reg [31: 0] imm,
  output [31: 0] src1,
  output [31: 0] src2,
  output reg [3: 0] alu_op,
  output reg [1: 0] pc_src,
  output reg [1: 0] reg_src,
  output reg alu_src,
  output reg [3: 0] rd_addr,
  output reg wen,

  output [3: 0] raddr1,
  output [3: 0] raddr2,
  input [31: 0] rdata1,
  input [31: 0] rdata2,

  output [31: 0] pc_out,
  output [31: 0] pc_sync_out,

  output reg [7: 0] wmask,
  output reg mem_wen,

  output reg valid,
  output reg [1: 0] width
);

  assign pc_out = pc_in;
  assign pc_sync_out = pc_sync_in;


  wire [6: 0] opcode;
  wire [4: 0] rs1;
  wire [4: 0] rs2;
  wire [4: 0] rd;
  wire [2: 0] funct3;
  wire [6: 0] funct7;
  wire [31: 0] Iimm;
  wire [31: 0] Simm;
  wire [31: 0] Bimm;
  wire [31: 0] Uimm;
  wire [31: 0] Jimm;

  assign opcode = inst_in[6: 0];
  assign rd = inst_in[11: 7];
  assign funct3 = inst_in[14: 12];
  assign rs1 = inst_in[19: 15];
  assign rs2 = inst_in[24: 20];
  assign funct7 = inst_in[31: 25];
  assign Iimm = {{20{inst_in[31]}}, inst_in[31: 20]};
  assign Simm = {{20{inst_in[31]}}, inst_in[31: 25], inst_in[11: 7]};
  assign Uimm = {inst_in[31: 12], 12'b0};
  assign Bimm = {{20{inst_in[31]}}, inst_in[7], inst_in[30: 25], inst_in[11: 8], 1'b0};
  assign Jimm = {{11{inst_in[31]}}, inst_in[31], inst_in[19: 12], inst_in[20], inst_in[30: 21], 1'b0};

  assign raddr1 = rs1[3: 0];
  assign raddr2 = rs2[3: 0];
  assign src1 = rdata1;
  assign src2 = rdata2;
  assign rd_addr = rd[3: 0];

  always@(*)begin
//	$display("%x, %x", pc_in, inst_in);
	imm = 32'b0;
	pc_src = `PC_NEXT;
	alu_src = `ALU_IMM;
	alu_op = `ALU_STOP;
	reg_src = `RD_ALU;
	wen = 0;
	wmask = 8'b0;
	mem_wen = 0;
	valid = 0;
	width = 0;
	case(opcode)
	  7'b0110111:begin   //LUI
		imm = Uimm;
		pc_src = `PC_NEXT;
		reg_src = `RD_IMM;
		wen = 1;
	  end
	  7'b1100111:begin   //JALR
		imm = Iimm & 32'hFFFFFFFE;
		pc_src = `PC_JALR;
		alu_op = `ALU_ADD;
		alu_src = `ALU_IMM;
		reg_src = `RD_PC;
		wen = 1;
	  end
	  7'b0000011:begin
		imm = Iimm;
		alu_src = `ALU_IMM;
		alu_op = `ALU_ADD;
		reg_src = `RD_MEM;
		wen = 1;
		valid = 1;
		if(funct3 == 3'b010)begin   //LW
		  width = `MEM_WORD;
		end
		else if(funct3 == 3'b100)begin  //LBU
		  width = `MEM_BYTE;
		end
	  end
	  7'b0100011:begin
		imm = Simm;
		alu_src = `ALU_IMM;
		alu_op = `ALU_ADD;
		wen = 0;
		valid = 1;
		mem_wen = 1;
//		$display("idu store: %08x, pc: %08x", src2, pc_in);
		if(funct3 == 3'b000)begin   //SB
		  width = `MEM_BYTE;
		end
		else if(funct3 == 3'b010)begin	  //SW
		  width = `MEM_WORD;
		end
	  end
	  7'b0010011:begin
		if(funct3 == 3'b000)begin   //ADDI
		  imm = Iimm;
		  pc_src = `PC_NEXT;
		  alu_src = `ALU_IMM;
		  alu_op = `ALU_ADD;
		  reg_src = `RD_ALU;
		  wen = 1;
		end
		else begin
		end
	  end
	  7'b0110011:begin
		if(funct3 == 3'b000 && funct7 == 7'b0000000)begin //ADD
		  pc_src = `PC_NEXT;
		  alu_src = `ALU_RS2;
		  alu_op = `ALU_ADD;
		  reg_src = `RD_ALU;
		  wen = 1;
		end
	  end
	  7'b1110011:begin		//EBREAK
		if(Iimm == 32'b1)
		  ebreak();
	  end
	  default begin
	  end
	endcase
  end

  function int get_Inst();
	return inst_in;
  endfunction

  function int get_Pc();
	return pc_in;
  endfunction

  export "DPI-C" function get_Inst;
  export "DPI-C" function get_Pc;

endmodule
