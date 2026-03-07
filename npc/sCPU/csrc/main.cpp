#include <stdio.h>
#include <stdlib.h>
#include <nvboard.h>
#include <Vtop.h>
#include <iostream>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME * top);

void one_cycle()
{
	dut.clk = 0;
	dut.eval();
	dut.clk = 1;
	dut.eval();
}

void init_n(int n)
{
	dut.rst = 1;
	while(n -- > 0) one_cycle();
	dut.rst = 0;
}

int main()
{
	nvboard_bind_all_pins(&dut);
	nvboard_init();
	
	init_n(10);

	while(1)
	{
		nvboard_update();
		one_cycle();
	}
	return 0;
}
