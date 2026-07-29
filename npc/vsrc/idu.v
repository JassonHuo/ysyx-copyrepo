`include "global.vh"
import "DPI-C" function void ebreak();
import "DPI-C" function void npc_abort();
module idu(
  input [31: 0] inst_in,
  input [31: 0] pc_in,
  input [31: 0] pc_sync_in,

  output reg [31: 0] imm,
  output [31: 0] src1,
  output [31: 0] src2,
  output reg [3: 0] alu_op,
  output reg [1: 0] pc_src,
  output reg [2: 0] reg_src,
  output reg alu_src,
  output reg [3: 0] rd_addr,
  output reg wen,
  output is_branch,
  output is_signed,

  output [3: 0] raddr1,
  output [3: 0] raddr2,
  input [31: 0] rdata1,
  input [31: 0] rdata2,

  input [31: 0] csr_data_in,
  output [2: 0] csr_type,
  output [11: 0] csr_addr,
  output [31: 0] csr_imm,
  output [31: 0] csr_data_out,

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
  wire [31: 0] Zimm;

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
  assign csr_addr = inst_in[31: 20];
  assign Zimm = {27'b0, inst_in[19: 15]};
  assign csr_data_out = csr_data_in;

  assign raddr1 = rs1[3: 0];
  assign raddr2 = rs2[3: 0];
  assign src1 = rdata1;
  assign src2 = rdata2;
  assign rd_addr = rd[3: 0];

  always@(*)begin
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
	is_branch = 0;
	is_signed = 0;
	csr_type = `CSR_NO;
	case(opcode)
	  7'b0110111:begin   //LUI
		imm = Uimm;
		pc_src = `PC_NEXT;
		reg_src = `RD_IMM;
		wen = 1;
	  end
	  7'b0010111:begin   //AUIPC
		imm = Uimm;
		pc_src = `PC_NEXT;
		reg_src = `RD_AUIPC;
		wen = 1;
	  end
	  7'b1101111:begin  //JAL
		pc_src = `PC_JAL;
		imm = Jimm;
		reg_src = `RD_PC;
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
	  7'b1100011:begin  //beq - bgeu
		imm = Bimm;
		is_branch = 1'b1;
		pc_src = `PC_BRANCH;
		is_signed = 1;
		alu_src = `ALU_RS2;
		case(funct3)
		  3'b000:begin //beq
			alu_op = `ALU_EQUAL;
		  end
		  3'b001:begin //bne
			alu_op = `ALU_NEQUAL;
		  end
		  3'b100:begin //blt
			alu_op = `ALU_SMALL;
		  end
		  3'b101:begin //bge
			alu_op = `ALU_LAREQ;
		  end
		  3'b110:begin //bltu
			is_signed = 1'b0;
			alu_op = `ALU_SMALL;
		  end
		  3'b111:begin //bgeu
			is_signed = 1'b0;
			alu_op = `ALU_LAREQ;
		  end
		  default:begin
			$display("branch abort");
			npc_abort();
		  end
		endcase
	  end
	  7'b0000011:begin   //lb - lhu
		imm = Iimm;
		alu_src = `ALU_IMM;
		alu_op = `ALU_ADD;
		reg_src = `RD_MEM;
		wen = 1;
		valid = 1;
		is_signed = 1;
		case(funct3)
		  3'b000:begin   //lb
			width = `MEM_BYTE;
		  end
		  3'b001:begin //lh
			width = `MEM_HALF;
		  end
		  3'b010:begin   //LW
			width = `MEM_WORD;
		  end
		  3'b100:begin  //LBU
			width = `MEM_BYTE;
			is_signed = 0;
		  end
		  3'b101:begin  //lhu
			width = `MEM_HALF;
			is_signed = 0;
		  end
		  default: begin
			$display("load abort");
			npc_abort();
		  end
		endcase 
	  end
	  7'b0100011:begin    //sb - sw
		imm = Simm;
		alu_src = `ALU_IMM;
		alu_op = `ALU_ADD;
		wen = 0;
		valid = 1;
		mem_wen = 1;
//		$display("idu store: %08x, pc: %08x", src2, pc_in);
		case(funct3)
		  3'b000:begin   //SB
			width = `MEM_BYTE;
		  end
		  3'b001:begin    //sh
			width = `MEM_HALF;
		  end
		  3'b010:begin	  //SW
			width = `MEM_WORD;
		  end
		  default begin
			$display("store abort");
			npc_abort();
		  end
		endcase
	  end
	  7'b0010011:begin				//addi - srai
		imm = Iimm;
		pc_src = `PC_NEXT;
		alu_src = `ALU_IMM;
		reg_src = `RD_ALU;
		wen = 1;
		is_signed = 1;
		case(funct3)
		  3'b000:begin   //ADDI
			alu_op = `ALU_ADD;
		  end
		  3'b010:begin   //slti
			alu_op = `ALU_SMALL;
		  end
		  3'b011:begin   //sltiu
			alu_op = `ALU_SMALL;
			is_signed = 0;
		  end
		  3'b100:begin	//xori
			alu_op = `ALU_XOR;
		  end
		  3'b110:begin	//ori
			alu_op = `ALU_OR;
		  end
		  3'b111:begin  //andi
			alu_op = `ALU_AND;
		  end
		  3'b001: begin
			if(funct7 == 7'b00000000)begin  //slli
			  alu_op = `ALU_LEFT;
			end
			else begin
			  $display("immi abort");
			  npc_abort();
			end
		  end
		  3'b101:begin
			if(funct7 == 7'b00000000)begin  //srli
			  alu_op = `ALU_RIGHT;
			  is_signed = 0;
			end
			else if(funct7 == 7'b0100000)begin //srai
			  alu_op = `ALU_RIGHT;
			end
			else begin
			  $display("immi abort");
			  npc_abort();
			end
		  end
		  default: begin
			$display("immi abort");
			npc_abort();
		  end
		endcase
	  end
	  7'b0110011:begin       //add - and
		pc_src = `PC_NEXT;
		alu_src = `ALU_RS2;
		reg_src = `RD_ALU;
		wen = 1;
		is_signed = 1;
		if(funct3 == 3'b000 && funct7 == 7'b0000000)begin //ADD
		  alu_op = `ALU_ADD;
		end
		else if(funct3 == 3'b000 && funct7 == 7'b0100000)begin  //sub
		  alu_op = `ALU_SUB;
		end
		else if(funct3 == 3'b001 && funct7 == 7'b0000000)begin  //sll
		  alu_op = `ALU_LEFT;
		end
		else if(funct3 == 3'b010 && funct7 == 7'b0000000)begin	//slt
		  alu_op = `ALU_SMALL;
		end
		else if(funct3 == 3'b011 && funct7 == 7'b0000000)begin  //sltu
		  alu_op = `ALU_SMALL;
		  is_signed = 0;
		end
		else if(funct3 == 3'b100 && funct7 == 7'b0000000)begin	//xor
		  alu_op = `ALU_XOR;
		end
		else if(funct3 == 3'b101 && funct7 == 7'b0000000)begin  //srl
		  alu_op = `ALU_RIGHT;
		  is_signed = 0;
		end
		else if(funct3 == 3'b101 && funct7 == 7'b0100000)begin  //sra
		  alu_op = `ALU_RIGHT;
		end
		else if(funct3 == 3'b110 && funct7 == 7'b0000000)begin  //or
		  alu_op = `ALU_OR;
		end
		else if(funct3 == 3'b111 && funct7 == 7'b0000000)begin  //and
		  alu_op = `ALU_AND;
		end
		else begin
		  $display("reg abort");
		  npc_abort();
		end
	  end
	  7'b1110011:begin
		csr_imm = Zimm;
		reg_src = `RD_CSR;
		wen = 1;
		is_signed = 0;
		case(funct3)
		  3'b000:begin
			if(csr_addr == 12'b1)
			  ebreak();
			else if(csr_addr == 12'b0)begin
			end
		  end
		  3'b001:begin  //csrrw
			csr_type = `CSR_RW;
		  end
		  3'b010:begin  //csrrs
			csr_type = `CSR_RS;
			alu_op = `ALU_OR;
		  end
		  3'b011:begin  //csrrc
			csr_type = `CSR_RC;
			alu_op = `ALU_AND;
		  end
		  3'b101:begin  //csrrwi
			csr_type = `CSR_RWI;
		  end
		  3'b110:begin  //csrrsi
			csr_type = `CSR_RSI;
			alu_op = `ALU_OR;
		  end
		  3'b111:begin  //csrrci
			csr_type = `CSR_RCI;
			alu_op = `ALU_AND;
		  end
		  default:begin
			$display("csr abort");
			npc_abort();
		  end
		endcase
	  end
	  default begin
		$display("default abort");
		npc_abort();
	  end
	endcase
  end

  function int get_Inst();
	return inst_in;
  endfunction

  /*
  function int get_Pc();
	return pc_in;
  endfunction
  */


  export "DPI-C" function get_Inst;
//  export "DPI-C" function get_Pc;

endmodule
