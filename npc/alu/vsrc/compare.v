module compare(
  input [7: 0] x,
  input [7: 0] y,
  output zf
);
  assign zf = (x == y);
  endmodule
