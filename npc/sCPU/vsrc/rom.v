module rom(
  input [3: 0] inst_addr_in,
  output [7: 0] inst_code_out
);

  reg [7: 0] rom_reg [0: 15];
  assign inst_code_out = rom_reg[inst_addr_in];

endmodule
