module adder(
  input sel,
  input [3: 0] x,
  input [3: 0] y,
  output [3: 0] z
);

  wire [3: 0] y_add = y ^ {4{sel}};

  assign z = x + y + sel;

endmodule
