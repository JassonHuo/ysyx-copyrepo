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

  always@(posedge clk)begin
	respValid = 1'b0;
	if(reqValid)begin
	  if(~wen)begin
		rdata <= pmem_read(addr);
	  end
	  else
		pmem_write(addr, wdata, {4'b0, mask});
	  respValid <= 1'b1;
	end
  end

endmodule
