#include <stdio.h>
#include <stdlib.h>
#include <Vtop.h>
#include <verilated.h>

#include "verilated_fst_c.h"

VerilatedContext *contextp = new VerilatedContext;

Vtop *top = new Vtop{contextp};

VerilatedFstC *tfp = new VerilatedFstC;

int main(int argc, char** argv)
{
  contextp->commandArgs(argc, argv);
  contextp->traceEverOn(true);

  top->trace(tfp, 99);

  tfp->open("wave.fst");

  top->clk = 1;
  top->rst = 0;

  top->rst = 1;
  int cycle = 50;

  while(cycle)
  {
	int in = rand() & 1;
	top->in = in;
	top->clk = !top->clk;
	top->eval();

	contextp->timeInc(1);
	tfp->dump(contextp->time());

	cycle--;
  }
  tfp->close();
  top->final();
  delete top;
  delete contextp;
  return 0;
}
