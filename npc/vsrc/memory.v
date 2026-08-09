module memory(
  input clk,
  input reqValid,
  input reqReady,
  input [31: 0] addr,
  input wen,
  input [31: 0] wdata,
  input [3: 0] mask,
  output reg respValid,
  input respReady,
  output reg [31: 0] rdata
);

/*
  parameter MEM_IDLE = 0, MEM_WAITRESP = 1;
  reg state, next_state;
  always@(*)begin
	case(state)
	  MEM_IDLE: next_state = reqValid ? MEM_WAITRESP: MEM_IDLE;
	  MEM_WAITRESP: next_state = respValid ? MEM_IDLE: MEM_WAITRESP;
	  default: next_state = MEM_IDLE;
	endcase
  end
  */

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
