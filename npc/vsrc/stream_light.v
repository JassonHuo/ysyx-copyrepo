module stream_light(
  input clk,
  input rst,
  output ld0,
  output ld1,
  output ld2,
  output ld3,
  output ld4,
  output ld5,
  output ld6,
  output ld7,
  output ld8,
  output ld9,
  output ld10,
  output ld11,
  output ld12,
  output ld13,
  output ld14,
  output ld15
);
  
  wire [15: 0] led;
  led[0] = 
