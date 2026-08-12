module memory(
  input clk,
  input arValid,
  output arReady,
  input [31: 0] araddr,

  output reg [31: 0] rdata,
  output rresp,
  output rValid,
  input rReady,

  input [31: 0] awaddr,
  input awValid,
  output awReady,

//  input wen,
  input [31: 0] wdata,
  input [3: 0] wstrb,
  input wValid,
  output wReady,

  output bresp,
  output bValid,
  input bReady
);

  //lsfm
  reg [7: 0] lsfm;
  reg [7: 0] counter;
  initial begin
	lsfm = 8'b00101001;
  end
  
  always@(posedge clk)begin
	lsfm <= {lsfm[6: 0], lsfm[0] ^ lsfm[3] ^ lsfm[7] ^ lsfm[2]};
  end
  //end

  parameter RIDLE = 0, ARREADY = 1, RWAIT = 2, RVALID = 3;
  reg [2: 0] rstate, next_rstate;
  always@(*)begin
	case(rstate)
	  RIDLE: next_rstate = arValid & (counter == 0 ? 1: 0) ? RWAIT: RIDLE;
//	  ARREADY: next_rstate = data_ready ? RVALID: RWAIT;
	  RWAIT: next_rstate = data_ready ? RVALID: RWAIT;
	  RVALID: next_rstate = rReady ? RIDLE: RVALID;
	  default: next_rstate = RIDLE;
	endcase
  end

  always@(posedge clk)begin
	rstate <= next_rstate;
  end

  assign arReady = (rstate == RIDLE);
  assign rValid = (rstate == RVALID);
  reg data_ready;

  always@(posedge clk)begin
	if(arValid & arReady)begin
		rdata <= pmem_read(araddr);
	end
	data_ready <= arValid;
//	counter <= (counter == 0 ? lsfm: counter - 1);
	counter <= 0;
  end

  /*
  parameter AW_IDLE = 0, AW_READY = 1, AW_DONE = 2;
  reg [2: 0] awstate, next_awstate;
  reg write_finish;
  always@(*)begin
	case(awstate)
	  AW_IDLE: next_awstate = awValid ? AW_READY: AW_IDLE;
	  AW_READY: next_awstate = AW_DONE;
	  AW_DONE: next_awstate = write_finish ? AW_IDLE: AW_DONE;
	  default: next_awstate = AW_IDLE;
	endcase
  end

  always@(posedge clk)begin
	awstate <= next_awstate;
  end

  assign awReady = (awstate == AW_READY);

  parameter DW_IDLE = 0, DW_READY = 1, DW_DONE = 2;
  reg [2: 0] dwstate, next_dwstate;
  always@(*)begin
	case(dwstate)
	  DW_IDLE: next_dwstate = wValid ? DW_READY: DW_IDLE;
	  DW_READY: next_dwstate = DW_DONE;
	  DW_DONE: next_dwstate = write_finish ? DW_IDLE: DW_DONE;
	  default: next_dwstate = DW_IDLE;
	endcase
  end

  always@(posedge clk)begin
	dwstate <= next_dwstate;
  end

  assign wReady = (dwstate == DW_READY);
  */

  parameter W_IDLE = 0, W_WAIT = 1, WRITE = 2, WAIT_BREADY = 3;
  reg [2: 0] wstate, next_wstate;
  reg write_finish;
  always@(*)begin
	case(wstate)
	  W_IDLE: next_wstate = awValid | wValid ? WRITE: W_IDLE;
//	  W_WAIT: next_wstate = (awstate == AW_DONE & dwstate == DW_DONE) ? WRITE: W_WAIT;
	  WRITE: next_wstate = write_finish ? WAIT_BREADY: WRITE;
	  WAIT_BREADY: next_wstate = bReady ? W_IDLE:  WAIT_BREADY;
	  default: next_wstate = W_IDLE;
	endcase
  end
  assign wReady = (wstate == W_IDLE);
  assign awReady = wReady;

  always@(posedge clk)begin
	wstate <= next_wstate;
  end

  assign bValid = (wstate == WAIT_BREADY);

  reg [31: 0] w_addr;
  reg [31: 0] w_data;
  reg [3: 0] w_mask;

  always@(posedge clk)begin
	write_finish <= 1'b0;
	if(awValid & awReady)
	  w_addr <= awaddr;
	if(wValid & wReady)begin
	  w_data <= wdata;
	  w_mask <= wstrb;
	end
	if(wstate == WRITE & ~write_finish)begin
	  pmem_write(w_addr, w_data, {4'b0, w_mask});
	  write_finish <= 1'b1;
	end
  end

endmodule
