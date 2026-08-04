module pc(
  input pc_en,
  input [31: 0] pc_in,
  input rst,
  input clk,

  output [31: 0] pc_out,
  output [31: 0] pc_sync
);
  (* verilator public_flat_rw *) reg [31: 0] pc = 32'h80000000;
  assign pc_sync = pc + 32'h4;

  always@(posedge clk)begin
//	$display("npc: %08x", pc);
	if(rst)
	  pc <= 32'h80000000;
	else if(pc_en)
	  pc <= pc_in;
	else 
	  pc <= pc;
  end
  assign pc_out = pc;

endmodule
