#include <nvboard.h>
#include <Vtop.h>
#include <stdio.h>
#include <stdlib.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME* top);

void one_cycle()
{
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

int main()
{
  nvboard_init();
  nvboard_bind_all_pins(&dut);
  int cnt = 0;

  while(1)
  {
	nvboard_update();
	one_cycle();
	printf("pixel[%d], valid[%d]: r = %d, g = %d, b = %d, hsync = %d, vsynv = %d\n", cnt, dut.valid_out, dut.vga_r, dut.vga_g, dut.vga_b, dut.hsync, dut.vsync);
	cnt ++;
  }
}
