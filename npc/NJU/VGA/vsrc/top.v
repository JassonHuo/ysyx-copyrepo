module top(
  input clk,
  input rst,
  output [7: 0] vga_r,
  output [7: 0] vga_g,
  output [7: 0] vga_b,
  output hsync,
  output vsync,
  output black,
  output valid_out
);

  assign black = valid;
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
  assign valid_out = !valid;
  
  parameter length = 307200;

  reg [23: 0] pic [0: 307200];
  wire [18: 0] pixaddr;
  assign pixaddr = {9'b0, v_addr} * 640 + {9'b0, h_addr};

  initial begin
	$readmemh("./white_test.txt", pic);
  end

  always@(*)begin
//	vga_data = valid ? pic[pixaddr]: 0;
	vga_data = valid ? 24'hFFFFFF: 0;
  end	

endmodule
