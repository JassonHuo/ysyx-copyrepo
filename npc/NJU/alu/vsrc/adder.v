module adder(
  input [3: 0] x,
  input [3: 0] y,
  input cel,
  output [3: 0] z,
  output overflow,
  output carry
);
  wire [3: 0] y1;
  assign y1 = {4{cel}} ^ y;
  assign {carry, z} = x + y1 + cel;
  assign overflow = (x[3] == 1 && y[3] == 1) ? (z[3] == 1 ? 0: 1): ((x[3] == 0 && y[3] == 0) ? (z[3] == 0 ? 0: 1): 0);
  endmodule  
