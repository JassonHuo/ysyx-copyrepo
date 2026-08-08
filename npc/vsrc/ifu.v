module ifu(
  input clk,
  input rst,
  input [31: 0] pc_in,
  input pc_en,

  output [31: 0] inst_addr,
  output reqValid,
  output reg respValid,
  input [31: 0] inst_in,

  output [31: 0] inst_out,
  output [31: 0] pc_sync_out,
  output valid,
  input ready,

  output [31: 0] pc_out,
  input done
);

  reg [1: 0] state, next_state;
  wire reqValid_tmp;
  reg respValid_tmp;

  assign reqValid = (state != `IF_RUNNING);
  assign inst_addr = pc_out;

  always@(*)begin
	if(rst)
	  next_state = `IF_IDLE;
	else
	  case(state)
		`IF_IDLE: next_state = `IF_WAIT;
		`IF_WAIT: next_state = respValid ? `IF_RUNNING: `IF_WAIT;
		`IF_RUNNING: next_state = done ? `IF_IDLE: `IF_RUNNING;
		default: next_state = `LS_IDLE;
	  endcase
	 /*
	 case(state)
	   `IF_IDLE: next_state = `IF_WAIT;
	   `IF_WAIT: next_state = done ? `IF_IDLE: `IF_WAIT;
	   default: next_state = `IF_IDLE;
	 endcase
	 */
  end

  always@(posedge clk)begin
	if(rst)
	  state <= `LS_IDLE;
	else
	  state <= next_state;
  end

//  assign valid = (state == `IF_RUNNING);
  assign valid = (state == `IF_RUNNING);
  
  reg [31: 0] inst;
  reg [3: 0] counter;
  reg [3: 0] lsfm;
  initial begin
	lsfm = 4'b1001;
  end
  always@(posedge clk)begin
	lsfm <= {lsfm[2: 0], lsfm[0] ^ lsfm[1] | lsfm [3]};
  end
  always@(posedge clk)begin
	inst <= inst;
	respValid <= reqValid;
	counter <= 4'b0;
	if(reqValid)begin
//	  inst <= pmem_read(inst_addr);
	  inst <= inst_in;
	end
  end
//  assign inst = pmem_read(pc_out);
  assign inst_out = inst;

  pc pc0(
	.pc_en(done & pc_en),
	.pc_in(pc_in),
	.rst(rst),
	.clk(clk),
	.pc_out(pc_out),
	.pc_sync(pc_sync_out)
  );

  /*
  RegisterFile #(
	.ADDR_WIDTH(8),
	.DATA_WIDTH(32)
  ) Rom(
	.clk(clk),
	.wdata(0),
	.waddr(0),
	.raddr1(pc_out[7: 0]),
	.raddr2(0),
	.rdata1(inst),
	.rdata2(),
	.wen(0)
  );
  */


endmodule
