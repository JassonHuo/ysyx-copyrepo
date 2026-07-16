#include <nvboard.h>
#include <Vtop.h>
#include <stdio.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME *top);

void one_cycle()
{
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

int main()
{
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  dut.rst = 1;
  one_cycle();
  dut.rst = 0;
  for(int i = 0; i < 255; i ++)
  {
	nvboard_update();
	one_cycle();
  }
  while(1) nvboard_update();
  return 0;
}
