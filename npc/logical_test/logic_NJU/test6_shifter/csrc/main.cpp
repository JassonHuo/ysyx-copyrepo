#include <nvboard.h>
#include <Vtop.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME *top);

static void one_cycle()
{
  dut.eval();
}

int main()
{
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  while(1)
  {
	nvboard_update();
	one_cycle();
  }
}
