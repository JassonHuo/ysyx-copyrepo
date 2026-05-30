#include <nvboard.h>
#include <Vtop.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME *top);

static void one_cycle()
{
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

static void reset(int n)
{
  dut.clr = 1;
  for (int i = 0; i < 10; i ++)
  {
	one_cycle();
  }
  dut.clr = 0;
}

int main(int argc, char* argv)
{
  nvboard_bind_all_pins(&dut);
  nvboard_init();
  reset(10);
  while(1)
  {
	nvboard_update();
	one_cycle();
  }
}
