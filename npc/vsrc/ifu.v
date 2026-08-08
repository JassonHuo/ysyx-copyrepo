module ifu(
  input clk,
  input rst,
  input [31: 0] pc_in,
  input pc_en,

//  output [31: 0] inst_addr,

  output [31: 0] inst_out,
  output [31: 0] pc_sync_out,
  output valid,
  input ready,

  output [31: 0] pc_out,
  input done
);

  reg state, next_state;

  always@(*)begin
	if(rst)
	  next_state = `LS_IDLE;
	else begin
	  case(state)
		`LS_IDLE: next_state = `LS_WAIT;
		`LS_WAIT: next_state = done ? `LS_IDLE: `LS_WAIT;
		default: next_state = `LS_IDLE;
	 endcase
	/*
	  case(state)
		`LS_IDLE: next_state = done ? `LS_WAIT: `LS_IDLE;
		`LS_WAIT: next_state = respValid ? `LS_IDLE: `LS_WAIT;
		default: next_state = `LS_IDLE;
	  endcase
	  */
	end
  end

  always@(posedge clk)begin
	if(rst)
	  state <= `LS_IDLE;
	else
	  state <= next_state;
  end

  /*
  parameter VALID_RUNNING = 1, VALID_WAITRESP = 0;
  reg valid_state, valid_next_state;
  always@(*)begin
	if(rst)
	  valid_next_state = VALID_RUNNING;
	case(valid_state)
	  VALID_RUNNING: valid_next_state = done ? VALID_WAITRESP: VALID_RUNNING;
	  VALID_WAITRESP: valid_next_state = respValid ? VALID_RUNNING: VALID_WAITRESP;
	endcase
  end

  always@(posedge clk)begin
	if(rst)
	  valid_state <= VALID_RUNNING;
	else
	  valid_state <= valid_next_state;
  end

  assign valid = valid_state;
  */
  assign valid = state;
  
  reg [31: 0] inst;
  reg respValid;
  wire reqValid;
  assign reqValid = ~state;
  always@(posedge clk)begin
	if(reqValid)
	  inst <= pmem_read(pc_out);
	respValid <= reqValid;
  end
//  assign inst = pmem_read(pc_out);
  assign inst_out = inst;
//  assign inst_addr = pc_out;

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
