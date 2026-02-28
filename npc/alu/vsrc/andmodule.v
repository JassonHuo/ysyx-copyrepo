module andmodule(
  input [7: 0] x,
  input [7: 0] y,
  output [7: 0] z
);
  assign z[0] = x[0] & y[0];
  assign z[1] = x[1] & y[1];
  assign z[2] = x[2] & y[2];
  assign z[3] = x[3] & y[3];
  assign z[4] = x[4] & y[4];
  assign z[5] = x[5] & y[5];
  assign z[6] = x[6] & y[6];
  assign z[7] = x[7] & y[7];
  endmodule
