module top(
  input [7: 0] in,
  output reg [2: 0] out
);


  integer i;
  always@(*)begin
	out = 3'b0;
	for(i = 7; i >= 0; i = i - 1)begin
	  if(in[i] == 1)begin
		out = i[2: 0];
		break;
	  end
	end
  end

endmodule
