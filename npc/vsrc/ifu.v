module ifu(
  input [31: 0] pc_in,
  input [31: 0] pc_sync_in,

  output [31: 0] inst_addr,

  output [31: 0] inst_out,
  output [31: 0] pc_sync_out,
  output [31: 0] pc_out
);

  wire [31: 0] inst;
  assign inst = pmem_read(pc_in);
  assign pc_sync_out = pc_sync_in;
  assign pc_out = pc_in;
  assign inst_out = inst;
  assign inst_addr = pc_in;


endmodule
