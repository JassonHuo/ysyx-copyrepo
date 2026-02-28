module top(
  input [15: 1] btn,
  output [3: 0] leds
);
  assign leds[0] = btn[1] | btn[3] | btn[5] | btn[7] | btn[9] | btn[11] | btn[13] | btn[15];
  assign leds[1] = btn[2] | btn[3] | btn[6] | btn[7] | btn[10] | btn[11] | btn[14] | btn[15];
  assign leds[2] = btn[4] | btn[5] | btn[6] | btn[7] | btn[12] | btn[13] | btn[14] | btn[15];
  assign leds[3] = btn[8] | btn[9] | btn[10] | btn[11] | btn[12] | btn[13] | btn[14] | btn[15];
endmodule
