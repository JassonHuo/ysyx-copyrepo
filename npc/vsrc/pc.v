module pc(
  input pc_en,
  input [31: 0] pc_in,
  input rst,
  input clk,

  output [31: 0] pc_out,
  output [31: 0] pc_sync
);
`ifdef VERILATOR
  (* verilator public_flat_rw *) reg [31: 0] pc = 32'h80000000;
`else
  reg [31: 0] pc = 32'h80000000;
`endif

  assign pc_sync = pc + 32'h4;

  always@(posedge clk)begin
	if(rst)
	  pc <= 32'h80000000;
	else if(pc_en)
	  pc <= pc_in;
	else 
	  pc <= pc;
  end
  assign pc_out = pc;

endmodule
