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

  output reg arValid,
  input arReady,
  output reg [31: 0] araddr,
  output rReady,
  input rValid,
  input [31: 0] rdata,
  input rresp,

  output [31: 0] awaddr,
  output awValid,
  input awReady,

  output [31: 0] wdata,
  output [3: 0] wstrb,
  output wValid,
  input wReady,

  input bresp,
  input bValid,
  output bReady
);

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

endmodule
