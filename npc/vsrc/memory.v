module memory(
  input clk,
  input reqValid,
  output reqReady,
  input [31: 0] addr,
  input wen,
  input [31: 0] wdata,
  input [3: 0] mask,
  output reg respValid,
  input respReady,
  output reg [31: 0] rdata
);

  parameter IDLE = 0, REQREADY = 1, WAIT = 2, RESPVALID = 3;
  reg [2: 0] state, next_state;
  always@(*)begin
	case(state)
	  /*
	  MEM_IDLE: next_state = reqValid ? MEM_WAITRESP: MEM_IDLE;
	  MEM_WAITRESP: next_state = respValid ? MEM_IDLE: MEM_WAITRESP;
	  default: next_state = MEM_IDLE;
	  */
	  IDLE: next_state = reqValid ? REQREADY: IDLE;
	  REQREADY: next_state = respValid ? RESPVALID: WAIT;
	  WAIT: next_state = respValid ? RESPVALID: WAIT;
	  RESPVALID: next_state = respReady ? IDLE: RESPVALID;
	  default: next_state = IDLE;
	endcase
  end

  assign reqReady = (state == REQREADY);

  always@(posedge clk)begin
	if(reqValid)begin
	  if (~wen)
		rdata <= pmem_read(addr);
	  if(wen)
		pmem_write(addr, wdata, {4'b0, mask});
	end
	respValid <= reqValid;
  end

  
endmodule
