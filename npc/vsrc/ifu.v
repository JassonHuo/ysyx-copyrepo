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
  input done,

  output arValid,
  input arReady,
  output [31: 0] araddr,
  output rReady,
  input rValid,
  input [31: 0] inst_in
);

//  reg state, next_state;

  reg [2: 0] state, next_state;
  parameter IF_WAITREQREADY = 0, IF_WAITRESP = 1, IF_RESPREADY = 2, IF_RUN = 3;

  always@(*)begin
	/*
   if(rst)
	 next_state = `IF_IDLE;
   else begin
	 case(state)
	   `IF_IDLE: next_state = respValid ? `IF_RUNNING: `IF_WAIT;
	   `IF_WAIT: next_state = respValid ? `IF_RUNNING: `IF_WAIT;
	   `IF_RUNNING: next_state = done ? `IF_IDLE: `IF_RUNNING;
	 endcase
   end
   */
	if(rst)
	  next_state = IF_WAITREQREADY;
	else begin
	  case(state)
		IF_WAITREQREADY: next_state = arReady ? IF_WAITRESP: IF_WAITREQREADY;
		IF_WAITRESP: next_state = rValid ? IF_RESPREADY: IF_WAITRESP;
		IF_RESPREADY: next_state = IF_RUN;
		IF_RUN: next_state = done ? IF_WAITREQREADY: IF_RUN;
		default: next_state = IF_WAITREQREADY;
	  endcase
	end
  end

  always@(posedge clk)begin
	if(rst)
	  state <= IF_WAITREQREADY;
	else
	  state <= next_state;
  end

  //lsfm
  reg [3: 0] lsfm;
  initial begin
	lsfm = 4'b1001;
  end
  always@(posedge clk)begin
	if(lsfm == 0)
	  lsfm <= 4'b1001;
	lsfm <= {lsfm[2: 0], lsfm[0] ^ lsfm[1] ^ lsfm[3]};
  end
  reg [3: 0] counter;
  //end

  assign valid = (state == IF_RUN);
//  assign valid = state;
//  assign valid = VALID_RUN;
  
  reg [31: 0] inst;
  /*
  wire respValid;
  wire reqValid;
  wire respReady;
  wire reqReady;
  */
  assign arValid = rst ? 1'b0: (state == IF_WAITREQREADY);
  assign rReady = (state == IF_RESPREADY);
  assign araddr = pc_out;

  /*
  memory mem0(
	.clk(clk),
	.reqValid(reqValid),
	.reqReady(reqReady),
	.addr(pc_out),
	.wen(0),
	.wdata(0),
	.mask(0),
	.respValid(respValid),
	.respReady(respReady),
	.rdata(inst_in)
  );
  */

  always@(posedge clk)begin
	if(respValid & respReady)
	  inst <= inst_in;
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


endmodule
