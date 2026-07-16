module sig_adder(
  input cin,
  input x,
  input y,
  output cout,
  output z
);
  wire nx, ny, nin;
  assign nx = ~x;
  assign ny = ~y;
  assign nin = ~cin;
  assign z = (nx & ny & cin) | (nx & y & nin) | (x & ny & nin) | (x & y & cin);
  assign cout = (nx & y & cin) | (x & ny & cin) | (x & y & nin) | (x & y & cin);
  endmodule  
