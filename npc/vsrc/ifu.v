module ifu(
  input clk,
  input rst,
  input [31: 0] pc_in,
  input pc_en,

  output [31: 0] inst_addr,
//  input [31: 0] inst_in,

  output [31: 0] inst_out,
  output [31: 0] pc_sync_out,
  output valid,
  input ready,

  output [31: 0] pc_out,
  input done
);

  reg state, next_state;
  /*
  always@(*)begin
	if(rst)
	  next_state = `IDLE;
	else begin
	  case(state)
		`IDLE: next_state = valid ? `WAIT_READY: `IDLE;
		`WAIT_READY: next_state = ready ? `IDLE: `WAIT_READY;
		default: next_state = state;
	  endcase
	end
  end

  always@(posedge clk)begin
	if(rst)
	  state <= `IDLE;
	else begin
	  state <= next_state;
	end
  end
  */
 always@(*)begin
   if(rst)
	 next_state = `LS_IDLE;
   else
	 case(state)
	   `LS_IDLE: next_state = `LS_WAIT;
	   `LS_WAIT: next_state = done ? `LS_IDLE; `LS_WAIT;
	   default: next_state = `LS_IDLE;
	 endcase
 end

 always@(posedge clk)begin
   if(rst)
	 state <= `LS_IDLE;
   else
	 state <= next_state;
 end

  assign valid = state;
  
  reg [31: 0] inst;
  always@(posedge clk)begin
	inst <= pmem_read(inst_addr);
  end
//  assign inst = pmem_read(pc_out);
  assign inst_out = inst;
  assign inst_addr = pc_out;

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
