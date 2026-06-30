#include <Vtop.h>
#include <nvboard.h>
#include <stdio.h>
#include <verilated.h>
#include <stdint.h>
#include <verilated_vcd_c.h>

static VerilatedContext *contextp = new VerilatedContext;
static VerilatedVcdC * tracep = new VerilatedVcdC;
static TOP_NAME *top = new Vtop;

void nvboard_bind_all_pins(TOP_NAME *top);

void one_cycle()
{
  top->clk = 0;
  top->eval();
  tracep->dump(contextp->time());
  contextp->timeInc(1);
  top->clk = 1;
  top->eval();
  tracep->dump(contextp->time());
  contextp->timeInc(1);
}

int main(int argc, char**argv)
{
  contextp->traceEverOn(true);
  top->trace(tracep, 99);
  tracep->open("wave.vcd");
  nvboard_bind_all_pins(top);
  nvboard_init();
  while(!contextp->gotFinish())
  {
	uint64_t counter = 100000000000;
	while(counter && !contextp->gotFinish())
	{
	  counter --;
	  nvboard_update();
	}
	one_cycle();
  }
  tracep->close();
  delete top;
  return 0;
}
