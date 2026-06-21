module top(
	input [3: 0] btn,
	output [15: 0] leds
);
	wire nn0, nn1, nn2, nn3, pn0, pn1, pn2, pn3;
	assign nn0 = ~btn[0];
	assign nn1 = ~btn[1];
	assign nn2 = ~btn[2];
	assign nn3 = ~btn[3];
	assign pn0 = btn[0];
	assign pn1 = btn[1];
	assign pn2 = btn[2];
	assign pn3 = btn[3];
	assign leds[0] = nn0 & nn1 & nn2 & nn3;
	assign leds[1] = pn0 & nn1 & nn2 & nn3;
	assign leds[2] = nn0 & pn1 & nn2 & nn3;
	assign leds[3] = pn0 & pn1 & nn2 & nn3;
	assign leds[4] = nn0 & nn1 & pn2 & nn3;
	assign leds[5] = pn0 & nn1 & pn2 & nn3;
	assign leds[6] = nn0 & pn1 & pn2 & nn3;
	assign leds[7] = pn0 & pn1 & pn2 & nn3;
	assign leds[8] = nn0 & nn1 & nn2 & pn3;
	assign leds[9] = pn0 & nn1 & nn2 & pn3;
	assign leds[10] = nn0 & pn1 & nn2 & pn3;
	assign leds[11] = pn0 & pn1 & nn2 & pn3;
	assign leds[12] = nn0 & nn1 & pn2 & pn3;
	assign leds[13] = pn0 & nn1 & pn2 & pn3;
	assign leds[14] = nn0 & pn1 & pn2 & pn3;
	assign leds[15] = pn0 & pn1 & pn2 & pn3;
endmodule
