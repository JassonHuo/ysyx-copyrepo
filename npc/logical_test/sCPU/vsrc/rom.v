module rom(
  input [3: 0] inst_addr_in,
  output [7: 0] inst_code_out
);

  reg [7: 0] rom_reg [0: 15];
  initial begin
	rom_reg[0] = 8'b10001010;	
	rom_reg[1] = 8'b10010000; 
	rom_reg[2] = 8'b10100000;
	rom_reg[3] = 8'b10110001;
	rom_reg[4] = 8'b00010111;
	rom_reg[5] = 8'b00101001;
	rom_reg[6] = 8'b11010001;
	rom_reg[7] = 8'b01000000;
  end
  assign inst_code_out = rom_reg[inst_addr_in];

endmodule
