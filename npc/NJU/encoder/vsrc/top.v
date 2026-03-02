module top(
  input [7: 0] in,
  output reg [2: 0] out,
  output no_zero,
  input en,
  output reg [7: 0] seg
);
 
  assign no_zero = (in != 8'b0);
  always@(*)begin
	if(en)begin
	  casez(in)
		8'b1zzzzzzz: begin
		  out = 7;
		  seg = 8'b11100000;
		end
		8'b01zzzzzz: begin
		  out = 6;
		  seg = 8'b10111110;
		end
		8'b001zzzzz: begin
		  out = 5;
		  seg = 8'b10110110;
		end
		8'b0001zzzz: begin
		  out = 4;
		  seg = 8'b01100110;
		end
		8'b00001zzz: begin
		  out = 3;
		  seg = 8'b11110010;
		end
		8'b000001zz: begin
		  out = 2;
		  seg = 8'b11011010;
		end
		8'b0000001z: begin
		  out = 1;
		  seg = 8'b01100000;
		end
		8'b00000001: begin
		  out = 0;
		  seg = 8'b11111100;
		end
		default: begin
		  out = 0;
		  seg = 8'b11111100;
		end
	  endcase
	end
	else out = 0;
  end
endmodule
