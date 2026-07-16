#include <nvboard.h>
#include <Vtop.h>
#include "verilated_vcd_c.h"

//static TOP_NAME* dut = new TOP_NAME;
//VerilatedVcdC *tfp = new VerilatedVcdC;
VerilatedContext* contextp = new VerilatedContext;

void nvboard_bind_all_pins(TOP_NAME *top);

void one_cycle(TOP_NAME *dut)
{
  dut->clk = 0;
  dut->eval();
  dut->clk = 1;
  dut->eval();
}

int main(int argc, char **argv)
{
  Verilated::traceEverOn(true);
  static TOP_NAME* dut = new TOP_NAME;
  VerilatedVcdC *tfp = new VerilatedVcdC;
  nvboard_bind_all_pins(dut);
  nvboard_init();
  Verilated::commandArgs(argc, argv);
  
  dut->trace(tfp, 99);
  tfp->open("wave.vcd");
  dut->rst = 1;
  one_cycle(dut);
  dut->rst = 0;

  long long cycle = 100000;
  while(1)
  {
	nvboard_update();
	one_cycle(dut);
	tfp->dump(1);
	cycle --;
  }
  return 0;
}
