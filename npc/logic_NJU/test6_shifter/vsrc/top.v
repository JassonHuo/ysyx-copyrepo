module top(
  input clk,
  output [6: 0] seg0,
  output [6: 0] seg1
);

  reg [7: 0] num;

  always@(posedge clk)begin
	num <= {num[4] ^ num[3] ^ num[2] ^ num[0], num[7: 1]};
  end

  seg_out seg00(
	.data(num[3: 0]),
	.seg(seg0)
  );

  seg_out seg01(
	.data(num[7: 4]),
	.seg(seg1)
  );

endmodule
