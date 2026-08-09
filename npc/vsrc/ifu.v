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

//  reg state, next_state;

  reg [1: 0] state, next_state;

  always@(*)begin
	/*
	if(rst)
	  next_state = `LS_IDLE;
	else begin
	  case(state)
		`LS_IDLE: next_state = `LS_WAIT;
		`LS_WAIT: next_state = done ? `LS_IDLE: `LS_WAIT;
		default: next_state = `LS_IDLE;
	 endcase
	end
	*/
   if(rst)
	 next_state = `IF_IDLE;
   else begin
	 case(state)
	   `IF_IDLE: next_state = respValid ? `IF_RUNNING: `IF_WAIT;
	   `IF_WAIT: next_state = respValid ? `IF_RUNNING: `IF_WAIT;
	   `IF_RUNNING: next_state = done ? `IF_IDLE: `IF_RUNNING;
	 endcase
   end
  end

  always@(posedge clk)begin
	if(rst)
	  state <= `LS_IDLE;
	else
	  state <= next_state;
  end

  /*
  parameter VALID_WAIT = 0, VALID_RUN = 1;
  reg valid_state, valid_next;
  always@(*)begin
	if(rst)
	  valid_next = VALID_RUN;
	else begin
	  case(state)
		VALID_WAIT: valid_next = respValid ? VALID_RUN: VALID_WAIT;
		VALID_RUN: valid_next = done ? VALID_WAIT: VALID_RUN;
		default: valid_next = VALID_RUN;
	  endcase
	end
  end

  always@(posedge clk)begin
	if(rst)
	  valid_state <= VALID_RUN;
	else
	  valid_state <= valid_next;
  end
  */

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

  assign valid = (state == `IF_RUNNING);
//  assign valid = state;
//  assign valid = VALID_RUN;
  
  reg [31: 0] inst;
  reg respValid;
  wire reqValid;
  assign reqValid = ~(|state);
  always@(posedge clk)begin
	respValid <= 0;
	if(reqValid)begin
	  inst <= pmem_read(pc_out);
	end
//	respValid <= reqValid;
	if(state == `IF_WAIT)begin
	  counter <= (counter == 0 ? lsfm: counter - 1);
	  respValid <= (counter == 0 ? 1: 0);
	end
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
