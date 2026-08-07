module memory(
  input clk,
  input reqValid,
//  output reqReady,
  input [31: 0] addr,
  input wen,
  input [31: 0] wdata,
  input [3: 0] mask,
  input respValid,
  output reg [31: 0] rdata
);

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
	if(reqValid)begin
	  if(wen)
		pmem_write(addr, wdata, {4'b0, mask});
	end
  end

  always@(*)begin
	rdata = pmem_read(addr);
  end
  
endmodule
