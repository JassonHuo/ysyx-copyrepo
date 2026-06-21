import "DPI-C" function void ebreak();
module pc(
  input pc_en,
  input [31: 0] pc_in,
  input rst,
  input clk,

  output [31: 0] pc_out,
  output [31: 0] pc_sync,
  input break_signal
);
  reg [31: 0] pc = 0'h80000000;
  assign pc_sync = pc + 32'h4;

  always@(posedge clk)begin
//	$display("%8x", pc);
	if(rst)
	  pc <= 32'h80000000;
	else if(break_signal)
	  ebreak();
	else if(pc_en)
	  pc <= pc_in;
	else
	  pc <= pc_sync;
  end

  assign pc_out = pc;

endmodule
