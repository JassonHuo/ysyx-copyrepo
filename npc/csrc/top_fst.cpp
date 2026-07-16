#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "Vtop.h"
#include "verilated.h"
#include "verilated_fst_c.h"

int main(int argc, char **argv)
{
	int i = 0;
	VerilatedContext *contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	Vtop *top = new Vtop{contextp};

	VerilatedFstC* tfp = new VerilatedFstC;
	contextp->traceEverOn(true);
	top->trace(tfp, 0);
	tfp->open("fst_wave.fst");
	while (i < 500) {
		int a = rand() & 1;
	  int b = rand() & 1;
		top->a = a;
	  top->b = b;
		top->eval();
		tfp->dump(contextp->time());
		contextp->timeInc(1);
		printf("a = %d, b = %d, f = %d\n", a, b, top->f);
		assert(top->f == (a ^ b));
		i ++;
	}
	delete top;
	tfp->close();
	delete contextp;
	return 0;
}
