module RegisterFile #(ADDR_WIDTH = 1, DATA_WIDTH = 1) (
  input clk,
  input [DATA_WIDTH-1:0] wdata,
  input [ADDR_WIDTH-1:0] waddr,
  input [ADDR_WIDTH-1:0] raddr1,
  input [ADDR_WIDTH-1:0] raddr2,
  output [DATA_WIDTH-1:0] rdata1,
  output [DATA_WIDTH-1:0] rdata2,
  input wen
);
`ifdef VERILATOR
  (* verilator public_flat_rw *) reg [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0];
`else
  reg [DATA_WIDTH-1:0] rf [2**ADDR_WIDTH-1:0];
`endif
  always @(posedge clk) begin
    if (wen && waddr != 0) rf[waddr] <= wdata;
  end
  assign rdata1 = rf[raddr1];
  assign rdata2 = rf[raddr2];

endmodule
