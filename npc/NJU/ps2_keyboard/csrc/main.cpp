#include <nvboard.h>
#include <Vtop.h>
#include <verilated.h>
#include <verilated_fst_c.h>

VerilatedContext *contextp = new VerilatedContext;
static TOP_NAME* dut = new TOP_NAME{contextp};
VerilatedFstC *tfp = new VerilatedFstC;

void nvboard_bind_all_pins(TOP_NAME *top);

void one_cycle()
{
  dut->clk = 0;
  dut->eval();
  if(dut->rst != 1 && dut->data_out != 0)
	contextp->timeInc(1);
  dut->clk = 1;
  dut->eval();
  if(dut->rst != 1 && dut->data_out != 0)
	contextp->timeInc(1);
}

int main(int argc, char **argv)
{
  nvboard_bind_all_pins(dut);
  nvboard_init();

  contextp->commandArgs(argc, argv);
  contextp->traceEverOn(true);
  dut->trace(tfp, 99);
  tfp->open("wave.fst");

  dut->rst = 0;
  one_cycle();
  dut->rst = 1;
  int data, last_data;
  data = 0;
  int cycle = 500000;
  while(1)
  {
	if(dut->rst != 1)
	  cycle --;
	nvboard_update();
	one_cycle();
	last_data = data;
	data = dut->data_out;
	if(data!= last_data)
	{
	  printf("%x\n", data);
	}
  }
  return 0;
}
