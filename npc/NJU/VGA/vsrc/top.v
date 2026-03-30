module top(
  input clk,
  input rst,
  output [7: 0] vga_r,
  output [7: 0] vga_g,
  output [7: 0] vga_b,
  output hsync,
  output vsync,
  output black
);

  assign black = 1'b1;
  vga_ctrl vc1(
	.pclk(clk),
	.reset(rst),
	.vga_data(vga_data),
	.h_addr(h_addr),
	.v_addr(v_addr),
	.hsync(hsync),
	.vsync(vsync),
	.valid(valid),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_b(vga_b)
  );

  reg [23: 0] vga_data;
  wire [9: 0] h_addr, v_addr;
  wire valid;
  
  parameter length = 3072;

  reg [23: 0] pic [0: 3071];

  reg [11: 0] ptr;

  initial begin
	$readmemh("./pic_hex/picture.txt", pic);
  end

  always@(posedge clk)begin
	if(rst)begin
	  ptr <= 12'b0;
	end
	else begin
	  if(valid)begin
		vga_data <= pic[ptr];
		$display("%x", pic[ptr]);
		ptr <= ptr + 1;
	  end	
	end
  end	

endmodule
