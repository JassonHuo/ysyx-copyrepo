#include <nvboard.h>
#include <Vtop.h>
#include <stdio.h>
#include <stdlib.h>
#include <verilated.h>
#include <verilated_fst_c.h>

VerilatedContext *contextp = new VerilatedContext;
static TOP_NAME *dut = new TOP_NAME{contextp};
VerilatedFstC * tfp = new VerilatedFstC;

void nvboard_bind_all_pins(TOP_NAME* top);

void one_cycle()
{
  dut->clk = 0;
  dut->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
  dut->clk = 1;
  dut->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

int main(int argc, char **argv)
{
  nvboard_init();
  nvboard_bind_all_pins(dut);
  dut->rst = 0;
  int cnt = 0;

  contextp->commandArgs(argc, argv);
  contextp->traceEverOn(true);
  contextp->trace(tfp, 99);
  tfp->open("./wave.fst");
  int cycle = 500000;

  while(cycle)
  {
	nvboard_update();
	  cycle --;
	one_cycle();
	if(dut->valid_out == 1)
	printf("pixel[%d], valid[%d]: r = %d, g = %d, b = %d, hsync = %d, vsynv = %d\n", cnt, dut->valid_out, dut->vga_r, dut->vga_g, dut->vga_b, dut->hsync, dut->vsync);
	cnt ++;
  }
}
