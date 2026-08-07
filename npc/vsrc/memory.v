module memory(
  input clk,
  input reqValid,
  input [31: 0] addr,
  input wen,
  input [31: 0] wdata,
  input [3: 0] mask,
  output reg respValid,
  output reg [31: 0] rdata
);

  reg [9: 0] counter;
  reg [9: 0] lfsr;
  initial begin
	lfsr = 10'b101;
  end

  always@(posedge clk)begin
	lfsr = {lfsr[8: 0], lfsr[0] ^ lfsr[3] ^ lfsr[7] ^ lfsr[9]};
  end

  /*
  reg [31: 0] addr_reg;
  reg wen_reg;
  reg [31: 0] wdata_reg;
  reg [3: 0] mask_reg;
  reg reqValid_reg;
  */

 /*
  always@(posedge clk)begin
	addr_reg <= addr_reg;
	wen_reg <= wen_reg;
	wdata_reg <= wdata_reg;
	mask_reg <= mask_reg;
	reqValid_reg <= reqValid_reg;
	if(reqValid)begin
	  addr_reg <= addr;
	  wen_reg <= wen;
	  wdata_reg <= wdata;
	  mask_reg <= mask;
	  reqValid_reg <= reqValid;
	end
	if(respValid)
	  reqValid_reg <= 1'b0;
  end
  */

  always@(posedge clk)begin
	respValid <= 1'b0;
//	counter <= (counter == 0) ? lfsr: counter - 1;
	counter <= 0;
	if(reqValid)begin
	  counter <= (counter == 0) ? lfsr: counter - 1;
	  if(~wen)begin
		rdata <= pmem_read(addr);
	  end
	  else
		pmem_write(addr, wdata, {4'b0, mask});
	  respValid <= (counter == 0) ? 1'b1: 1'b0;
	end
  end

endmodule
