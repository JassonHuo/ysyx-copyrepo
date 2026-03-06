module inst_deco(
  input [7: 0] inst_in,
  output [1: 0] opcode,
  output [1: 0] rs1,
  output [1: 0] rs2,
  output [1: 0] rd,
  output [3: 0] imm,
  output [3: 0] addr
);

  assign {opcode, rd, rs1, rs2} = inst_in;
  assign imm = inst_in[3: 0];
  assign addr = inst_in[5: 2];

endmodule
