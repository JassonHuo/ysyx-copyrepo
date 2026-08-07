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

  reg [31: 0] addr_reg;
  reg wen_reg;
  reg [31: 0] wdata_reg;
  reg [3: 0] mask_reg;
  reg reqValid_reg;

  always@(posedge clk)begin
	addr_reg <= addr_reg;
	wen_reg <= wen_reg;
	wdata_reg <= wdata_reg;
	mask_reg <= mask_reg;
	if(reqValid)begin
	  addr_reg <= addr;
	  wen_reg <= wen;
	  wdata_reg <= wdata;
	  mask_reg <= mask;
	end
  end

  parameter MEM_IDLE = 0, MEM_WAITRESP = 1;
  reg state, next_state;
  always@(*)begin
	case(state)
	  MEM_IDLE: next_state = reqValid ? MEM_WAITRESP: MEM_IDLE;
	  MEM_WAITRESP: next_state = respValid ? MEM_IDLE: MEM_WAITRESP;
	  default: next_state = MEM_IDLE;
	endcase
  end

  always@(posedge clk)begin
	if(reqValid)begin
	  if(wen_reg)
		pmem_write(addr_reg, wdata_reg, {4'b0, mask_reg});
	end
  end

  always@(*)begin
	if(respValid)
	  rdata = pmem_read(addr_reg);
	else
	  rdata = 32'b0;
  end
  
endmodule
