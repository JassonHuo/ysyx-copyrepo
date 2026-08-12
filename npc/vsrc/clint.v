module clint(
  input clk,
  input arValid,
  output arReady,
  input [31: 0] araddr,
  input rReady,
  output rValid,
  output reg [31: 0] rdata,
  output rresp,

  input [31: 0] awaddr,
  input awValid,
  output awReady,

  input [31: 0] wdata,
  input [3: 0] wstrb,
  input wValid,
  output wReady,

  output bresp,
  output bValid,
  input bReady
);

  reg [31: 0] mtime, mtimeh;

  reg state, next_state;
  parameter IDLE = 0, WAIT_RREADY = 1;
  always@(*)begin
	case(state)
	  IDLE: next_state = arValid ? WAIT_RREADY: IDLE;
	  WAIT_RREADY: next_state = rReady ? IDLE: WAIT_RREADY;
	  default: next_state = IDLE;
	endcase
  end

  reg [31: 0] addr;

  always@(posedge clk)begin
	state <= next_state;
	mtime <= mtime + 1;
	mtimeh <= (mtime == 32'hffffffff) ? mtimeh + 1: mtimeh;
	if(arValid & arReady)begin
	  addr <= araddr;
	  `ifdef VERILATOR
		TO_device();
	  `endif
	end
  end

  assign arReady = ~state;
  assign rValid = state;
  always@(*)begin
	if(addr == 32'h02000000)
	  rdata = mtime;
	else if(addr == 32'h02000004)
	  rdata = mtimeh;
	else
	  rdata = 32'b0;
  end

endmodule
