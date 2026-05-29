module top(
  input [7: 0] in,
  output reg [2: 0] out
);


  integer i;
  always@(*)begin
	out = 3'b0;
	for(i = 0; i < 8; i = i + 1)begin
	  if(in[i] == 1)
		out = i[2: 0];
	  else
		out = 0;
	end
  end

endmodule
