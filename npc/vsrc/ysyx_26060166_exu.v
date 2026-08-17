`include "global.vh"
module ysyx_26060166_exu(
  input clk,
  input rst,
  input [31: 0] pc_in,
  input [31: 0] pc_sync_in,

  input [31: 0] imm,
  input [31: 0] src1,
  input [31: 0] src2,
  input [3: 0] alu_op,
  input [2: 0] pc_src,
  input [2: 0] reg_src,
  input alu_src,
  input [3: 0] rd_addr,
  input wen,

  input mem_wen,
  input [7: 0] wmask,
  input mem_valid,
  input [1: 0] width,
  input is_signed,
  input is_branch,

  input [2: 0] csr_type,
  input [31: 0] csr_imm,
  input [31: 0] csr_data_in,
  input [11: 0] csr_addr,

  output [2: 0] csr_type_out,
  output [31: 0] csr_imm_out,
  output [31: 0] csr_data_out,
  output [11: 0] csr_addr_out,
  output [31: 0] src1_out,

  output [31: 0] alu_out,
  output [31: 0] pc_sync_out,
  output [31: 0] pc_out,

  output [2: 0] pc_src_out,
  output [2: 0] reg_src_out,
  output [3: 0] rd_addr_out,
  output wen_out,

  output [31: 0] imm_out,

  output [31: 0] pc_plus_imm,

  output mem_wen_out,
  output [7: 0] wmask_out,
  output mem_valid_out,
  output [31: 0] src2_out,
  output [1: 0] width_out,
  output is_signed_out,

  input valid_pre,
  output ready_pre,
  output reg valid_aft,
  input ready_aft

);

  reg state, next_state;

  always@(*)begin
	if(rst)
	  next_state = `IDLE;
	else begin
	  case(state)
		`IDLE: next_state = valid_aft ? `WAIT_READY: `IDLE;
		`WAIT_READY: next_state = ready_aft ? `IDLE: `WAIT_READY;
		default: next_state = `IDLE;
	  endcase
	end
  end

//  assign ready_pre = valid_pre & (state == `IDLE);

  always@(posedge clk)begin
	if(rst)
	  state <= `IDLE;
	else begin
	  state <= next_state;
	end
  end

  assign ready_pre = valid_pre;
  assign valid_aft = ready_pre & valid_pre;

  assign pc_sync_out = pc_sync_in;
  assign pc_out = pc_in;
  assign pc_src_out = pc_src;
  assign reg_src_out = reg_src;
  assign rd_addr_out = rd_addr;
  assign wen_out = wen;
  assign is_signed_out = is_signed;

  assign imm_out = imm;

  assign pc_plus_imm = pc_in + imm;

  assign mem_wen_out = mem_wen;
  assign wmask_out = wmask; 
  assign mem_valid_out = mem_valid;

  assign src2_out = src2;

  assign width_out = width;


  assign csr_type_out = csr_type;
  assign csr_imm_out = csr_imm;
  assign csr_data_out = csr_data_in;
  assign csr_addr_out = csr_addr;
  assign src1_out = src1;

  wire zero;
  reg [31: 0] alu_num1;
  reg [31: 0] alu_num2;

  always@(*)begin
	case(csr_type)
	  `CSR_RC: begin
		alu_num1 = ~src1;
		alu_num2 = csr_data_in;
	  end
	  `CSR_RS: begin
		alu_num1 = src1;
		alu_num2 = csr_data_in;
	  end
	  `CSR_RCI: begin
		alu_num1 = ~csr_imm;
		alu_num2 = csr_data_in;
	  end
	  `CSR_RSI: begin
		alu_num1 = csr_imm;
		alu_num2 = csr_data_in;
	  end
	  default: begin
		alu_num1 = src1;
		alu_num2 = (alu_src == `ALU_IMM ? imm: src2);
	  end
	endcase
  end

  ysyx_26060166_alu alu0(
	.x(alu_num1),
	.y(alu_num2),
	.alu_op(alu_op),
	.z(alu_out),
	.zero(zero),
	.is_signed(is_signed)
  );


endmodule
