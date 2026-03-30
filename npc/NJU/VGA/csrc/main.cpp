#include <nvboard.h>
#include <Vtop.h>
#include <stdio.h>

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

  while(1)
  {
	nvboard_update();
	one_cycle();
  }
}
