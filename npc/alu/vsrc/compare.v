module compare(
  input [3: 0] x,
  input [3: 0] y,
  output zf
);
  assign zf = (x == y);
  endmodule
