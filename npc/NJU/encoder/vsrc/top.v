module top(
  input [7: 0] in,
  output reg [2: 0] out,
  output no_zero,
  input en
);
 
  assign no_zero = (in != 8'b0);
  integer i;
  always@(*)begin
	if(en)begin
		out = 3'b0;
		for (i = 0; i < 8; i = i + 1) if(in[i] == 1) out = i[2: 0];
	end
	else out = 0;
  end
endmodule
