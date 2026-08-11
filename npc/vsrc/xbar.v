module xbar(
  input ifu_arValid,
  output ifu_arReady,
  input [31: 0] ifu_araddr,
  input ifu_rReady,
  output ifu_rValid,
  output reg [31: 0] ifu_rdata,
  output ifu_rresp,

  input lsu_arValid,
  output lsu_arReady,
  input [31: 0] lsu_araddr,
  input lsu_rReady,
  output lsu_rValid,
  output reg [31: 0] lsu_rdata,
  output lsu_rresp,

  input [31: 0] lsu_awaddr,
  input lsu_awValid,
  output lsu_awReady,

  input [31: 0] lsu_wdata,
  input [3: 0] lsu_wstrb,
  input lsu_wValid,
  output lsu_wReady,

  output lsu_bresp,
  output lsu_bValid,
  input lsu_bReady,

  output mem_arValid,
  input mem_arReady,
  output [31: 0] mem_araddr,
  output mem_rReady,
  input mem_rValid,
  input [31: 0] mem_rdata,
  input mem_rresp,

  output [31: 0] mem_awaddr,
  output mem_awValid,
  input mem_awReady,

  output [31: 0] mem_wdata,
  output [3: 0] mem_wstrb,
  output mem_wValid,
  input mem_wReady,

  input mem_bresp,
  input mem_bValid,
  output mem_bReady,

  output uart_arValid,
  input uart_arReady,
  output [31: 0] uart_araddr,
  output uart_rReady,
  input uart_rValid,
  input [31: 0] uart_rdata,
  input uart_rresp,

  output [31: 0] uart_awaddr,
  output uart_awValid,
  input uart_awReady,

  output [31: 0] uart_wdata,
  output [3: 0] uart_wstrb,
  output uart_wValid,
  input uart_wReady,

  input uart_bresp,
  input uart_bValid,
  output uart_bReady
);

  reg arValid;
  wire arReady;
  reg [31: 0] araddr;
  wire rReady;
  reg rValid;
  reg [31: 0] rdata;
  wire rresp;

  wire [31: 0] awaddr;
  wire awValid;
  wire awReady;
  
  wire [31: 0] wdata;
  wire [3: 0] wstrb;
  wire wValid;
  wire wReady;

  wire bresp;
  wire bValid;
  wire bReady;

  assign awaddr = lsu_awaddr;
  assign awValid = lsu_awValid;
  assign lsu_awReady = awReady;
  assign wdata = lsu_wdata;
  assign wstrb = lsu_wstrb;
  assign wValid = lsu_wValid;
  assign lsu_wReady = wReady;
  assign lsu_bresp = bresp;
  assign lsu_bValid = bValid;
  assign bReady = lsu_bReady;

  always@(*)begin
	arValid = 0;
	araddr = 0;
	if(ifu_arValid)begin
	  arValid = ifu_arValid;
	  araddr = ifu_araddr;
	end
	else if(lsu_arValid)begin
	  arValid = lsu_arValid;
	  araddr = lsu_araddr;
	end
  end

  assign ifu_rValid = rValid;
  assign lsu_rValid = rValid;
  assign ifu_arReady = arReady;
  assign lsu_arReady = arReady;
  assign rReady = ifu_rReady | lsu_rReady;

  always@(*)begin
	lsu_rdata = 32'b0;
	ifu_rdata = 32'b0;
	lsu_rresp = 1'b0;
	ifu_rresp = 1'b0;
	if(lsu_rReady)begin
	  lsu_rdata = rdata;
	  lsu_rresp = 1'b1;
	end
	else if(ifu_rReady)begin
	  ifu_rdata = rdata;
	  ifu_rresp = 1'b1;
	end
  end

  assign awReady = mem_awReady | uart_awReady;
  assign wReady = mem_wReady | uart_wReady;
  assign bresp = mem_bresp | uart_bresp;
  assign bValid = mem_bValid | uart_bValid;

  assign arReady = mem_arReady | uart_arReady;
  assign rValid = mem_rValid | uart_rValid;
  assign rresp = mem_rresp | uart_rresp;

  assign mem_rReady = rReady;
  assign uart_rReady = rReady;
  assign rdata = mem_rdata | uart_rdata;
  
  always@(*)begin
	mem_awaddr = 0;
	mem_awValid = 0;
	mem_wdata = 0;
	mem_wstrb = 0;
	mem_wValid = 0;
	mem_bReady = 0;
	mem_arValid = 0;
	mem_araddr = 0;
	uart_awaddr = 0;
	uart_awValid = 0;
	uart_wdata = 0;
	uart_wstrb = 0;
	uart_wValid = 0;
	uart_bReady = 0;
	if(araddr >= 32'h80000000 & araddr <= 32'h80ffffff)begin
	  mem_arValid = arValid;
	  mem_araddr = araddr;
	end
	if(awaddr >= 32'h80000000 & awaddr <= 32'h80ffffff)begin
	  mem_awaddr = awaddr;
	  mem_awValid = awValid;
	  mem_wdata = wdata;
	  mem_wstrb = wstrb;
	  mem_wValid = wValid;
	  mem_bReady = bReady;
	end
	else if(awaddr >= 32'h10000000 & awaddr <= 32'h10000fff)begin
	  uart_awaddr = awaddr;
	  uart_awValid = awValid;
	  uart_wdata = wdata;
	  uart_wstrb = wstrb;
	  uart_wValid = wValid;
	  uart_bReady = bReady;
	end
  end

endmodule
