module inst_fetch(
  input [3: 0] pc_in,
  output [3: 0] rom_addr_out,
  input [7: 0] rom_in,
  output [7: 0] inst_out
);

  assign rom_addr_out = pc_in;  
  assign inst_out = rom_in;

endmodule
