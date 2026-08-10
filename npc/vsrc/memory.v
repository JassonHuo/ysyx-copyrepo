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

  parameter IDLE = 0, REQREADY = 1, WAIT = 2, RESPVALID = 3;
  reg [2: 0] state, next_state;
  always@(*)begin
	case(state)
	  IDLE: next_state = reqValid & (counter == 0 ? 1: 0) ? REQREADY: IDLE;
	  REQREADY: next_state = data_ready ? RESPVALID: WAIT;
	  WAIT: next_state = data_ready ? RESPVALID: WAIT;
	  RESPVALID: next_state = respReady ? IDLE: RESPVALID;
	  default: next_state = IDLE;
	endcase
  end

  always@(posedge clk)begin
	state <= next_state;
  end

  assign reqReady = (state == REQREADY);
  assign respValid = (state == RESPVALID);
  reg data_ready;

  always@(posedge clk)begin
	if(reqValid & reqReady)begin
	  if (~wen)
		rdata <= pmem_read(addr);
	  if(wen)
		pmem_write(addr, wdata, {4'b0, mask});
	end
	data_ready <= reqValid;
//	counter <= (counter == 0 ? lsfm: counter - 1);
	counter <= 0;
  end

  
endmodule
