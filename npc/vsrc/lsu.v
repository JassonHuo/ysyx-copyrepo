//import "DPI-C" function int pmem_read(input int raddr);
//import "DPI-C" function void pmem_write(input int waddr, input int wdata, input byte wmask);

module lsu(
  input clk,
  input rst,
  input [31: 0] pc_sync_in,
  input [31: 0] pc_in,

  input [31: 0] alu,
  input [2: 0] pc_src,
  input [2: 0] reg_src,
  input [3: 0] rd_addr,
  input wen,

  input [31: 0] imm,

  input [31: 0] pc_plus_imm,

  input mem_wen,
  input [7: 0] wmask,
  input mem_valid,
  input [31: 0] src2,

  input [1: 0] width,
  input is_signed,

  
  input [2: 0] csr_type,
  input [31: 0] csr_imm,
  input [31: 0] csr_data_in,
  input [11: 0] csr_addr,
  input [31: 0] src1,

  output [2: 0] csr_type_out,
  output [31: 0] csr_imm_out,
  output [31: 0] csr_data_out,
  output [11: 0] csr_addr_out,
  output [31: 0] src1_out,

  output [31: 0] pc_sync_out,
  output [31: 0] pc_out,
  output [31: 0] alu_out,
  output [2: 0] pc_src_out,
  output [2: 0] reg_src_out,
  output [3: 0] rd_addr_out,
  output wen_out,

  output [31: 0] imm_out,

  output [31: 0] pc_plus_imm_out,
  output reg [31: 0] rdata,

  input valid_pre,
  output ready_pre,
  output reg valid_aft,
  input ready_aft
);

  reg state, next_state;
  wire pre_succ = valid_pre & ready_pre;

  always@(*)begin
	if(rst)
	  next_state = `IDLE;
	else begin
	  case(state)
		`IDLE: next_state = valid_aft ? `WAIT_READY: `IDLE;
		`WAIT_READY: next_state = ready_aft ? `IDLE: `WAIT_READY;
	  endcase
	end
  end

  assign ready_pre = valid_pre & (state == `IDLE);

  always@(posedge clk)begin
	if(rst)
	  state <= `IDLE;
	else begin
	  state <= next_state;
	end
  end

  assign pc_sync_out = pc_sync_in;
  assign pc_out = pc_in;
  assign alu_out = alu;
  assign pc_src_out = pc_src;
  assign reg_src_out = reg_src;
  assign rd_addr_out = rd_addr;
  assign wen_out = wen; 
  assign imm_out = imm;

  assign pc_plus_imm_out = pc_plus_imm;

  assign csr_type_out = csr_type;
  assign csr_imm_out = csr_imm;
  assign csr_data_out = csr_data_in;
  assign csr_addr_out = csr_addr;

  assign src1_out = src1;

  reg [1: 0] mem_data;
  wire [3: 0] mask = (width == `MEM_WORD ? 4'b1111:
	(width == `MEM_HALF ? 4'b11 << alu[1: 0]:
	(width == `MEM_BYTE ? 4'b1  << alu[1: 0] : 4'b0)));

  always@(*)begin
	if(mem_valid)begin
	  rdata = (/*pmem_read(alu)*/ >> {alu[1: 0], 3'b0}) & (width == `MEM_WORD ? ~32'b0:
		(width == `MEM_HALF ? 32'hFFFF:
		(width == `MEM_BYTE ? 32'hFF: 32'b0)));
	  rdata = rdata | (width == `MEM_HALF ? {{16{is_signed & rdata[15]}}, 16'b0}:
		(width == `MEM_BYTE ? {{24{is_signed & rdata[7]}}, 8'b0}: 32'b0));
	  if(mem_wen)begin
//		pmem_write(alu, src2, {4'b0, mask});
	  end
	end
	else
	  rdata = 0;
  end

endmodule
