#include <nvboard.h>
#include <Vtop.h>

static TOP_NAME* dut = new TOP_NAME;

void nvboard_bind_all_pins(TOP_NAME *top);

void one_cycle()
{
  dut->clk = 0;
  dut->eval();
  dut->clk = 1;
  dut->eval();
}

int main(int argc, char **argv)
{
  nvboard_bind_all_pins(dut);
  nvboard_init();

  dut->rstn = 0;
  one_cycle();
  dut->rstn = 1;
  while(1)
  {
	nvboard_update();
	one_cycle();
  }
  return 0;
}
