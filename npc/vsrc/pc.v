module pc(
  input pc_en,
  input [31: 0] pc_in,
  input rst,
  input clk,

  output [31: 0] pc_out,
  output [31: 0] pc_sync
);
  reg [31: 0] pc = 0'h80000000;
  assign pc_sync = pc + 32'h4;

  always@(posedge clk)begin
//	$display("%8x", pc);
	if(rst)
	  pc <= 32'h80000000;
	else if(pc_en)
	  pc <= pc_in;
	else
	  pc <= pc_sync;
  end
  function int get_Pc();
	return pc;
  endfunction
  export "DPI-C" function get_Pc;

  assign pc_out = pc;

endmodule
