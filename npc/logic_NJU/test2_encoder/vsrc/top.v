module top(
  input [7: 0] in,
  input en,
  output reg [2: 0] out,
  output reg flag
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

endmodule
