module add_suber(
  input [3: 0] x,
  input [3: 0] y,
  input cin,
  output [3: 0] z,
  output overflow,
  output cout
);

  wire [3: 0] y1;
  assign y1 = (y ^ {4{cin}}) + cin;
  assign {cout, z} = y1 + x;

  assign overflow = (x[3] == y1[3]) && (z[3] != x[3]); 

endmodule
