module top(
  input [7: 0] in,
  input en,
  output reg [2: 0] out,
  output reg flag,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3
);


  integer i;
  always@(*)begin
	out = 3'b0;
	flag = 1'b0;
	if(en == 1)begin
	  for(i = 7; i >= 0; i = i - 1)begin
		if(in[i] == 1)begin
		  out = i[2: 0];
		  flag = 1;
		  break;
		end
	  end
	end
  end

  seg seg00(
	.data({2'b0, out[0]}),
	.seg(seg0)
  );

  seg seg01(
	.data({2'b0, out[1]}),
	.seg(seg1)
  );
  
  seg seg02(
	.data({2'b0, out[2]}),
	.seg(seg2)
  );

  seg seg03(
	.data({2'b0, flag}),
	.seg(seg3)
  );

endmodule
