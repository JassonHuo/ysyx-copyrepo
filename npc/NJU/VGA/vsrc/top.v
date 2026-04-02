module top(
  input clk,
  input rst,
  output [7: 0] vga_r,
  output [7: 0] vga_g,
  output [7: 0] vga_b,
  output hsync,
  output vsync,
  output blank,
  output valid_out
);

  vga_ctrl vc1(
	.pclk(vga_clk),
	.reset(rst),
	.vga_data(vga_data),
	.h_addr(h_addr),
	.v_addr(v_addr),
	.hsync(hsync),
	.vsync(vsync),
	.valid(blank),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_b(vga_b)
  );


  wire vga_clk;
  assign vga_clk = clk;
  reg [23: 0] vga_data;
  wire [9: 0] h_addr, v_addr;
  wire valid;
  assign valid_out = valid;
  

  reg [23: 0] pic [524287: 0];

  initial begin
//	$readmemh("/home/jasonhuo/ysyx/ysyx-workbench/nvboard/example/resource/picture.hex", pic);
	$readmemh("/home/jasonhuo/ysyx/ysyx-workbench/npc/NJU/VGA/test_picture.txt", pic);
  end

//  assign vga_data = pic[{h_addr, v_addr[8: 0]}];
  assign vga_data = pic[v_addr * 640 + h_addr];

endmodule
