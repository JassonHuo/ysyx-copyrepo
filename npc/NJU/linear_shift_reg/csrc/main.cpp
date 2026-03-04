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
  int counter = 0;
  while (1)
  {
	if(counter >= 255) continue;
	printf("%d\n", counter);
	nvboard_update();
	one_cycle();
  }
  return 0;
}
