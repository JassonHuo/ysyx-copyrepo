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
  top->rst = 1;
  for(int i = 0; i < 10; i ++)
	one_cycle();
  top->rst = 0;
  /*
  while(!contextp->gotFinish())
  {
	uint64_t counter = 1000000000;
	one_cycle();
	nvboard_update();
	while(counter && !contextp->gotFinish())
	{
	  counter --;
	  nvboard_update();
	}
  }
  */
  tracep->close();
  delete top;
  return 0;
}
