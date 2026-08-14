import "DPI-C" function void TO_device();
module uart(
  input clk,
  input arValid,
  output arReady,
  input [31: 0] araddr,
  input rReady,
  output rValid,
  output [31: 0] rdata,
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

  parameter IDLE = 0, WRITE = 1, WAIT_BREADY = 2;
  reg [1: 0] state, next_state;
  always@(*)begin
	case(state)
	  IDLE: next_state = (awValid & wValid) ? WRITE: IDLE;
	  WRITE: next_state = WAIT_BREADY;
	  WAIT_BREADY: next_state = bReady ? IDLE: WAIT_BREADY;
	  default: next_state = IDLE;
	endcase
  end

  always@(posedge clk)begin
	state <= next_state;
  end

  assign awReady = (state == IDLE);
  assign wReady = awReady;
  assign bValid = (state == WAIT_BREADY);

  always@(*)begin
	if(state == WRITE)begin
	  $write("%c", wdata[7: 0]);
	  TO_device();
	end
  end

endmodule
