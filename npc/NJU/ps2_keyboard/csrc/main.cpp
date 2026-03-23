#include <nvboard.h>
#include <Vtop.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(TOP_NAME *top);

void one_cycle()
{
  dut.clk = 0;
  dut.eval();
  dut.clk = 1;
  dut.eval();
}

int main()
{
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  dut.rst = 0;
  one_cycle();
  dut.rst = 1;
  int data, last_data;
  int reading, reading_last, ready, ready_last;
  data = 0;
  reading = 0;
  ready = 0;
  while(1)
  {
	nvboard_update();
	one_cycle();
	last_data = data;
	reading_last = reading;
	ready_last = ready;
	ready = dut.ready_debug;
	reading = dut.reading_debug;
	data = dut.data_out;
	if(data!= last_data)
	{
	  printf("%x\n", data);
	}
	if(reading != reading_last || ready != ready_last)
	  printf("reading: %d, ready: %d\n", reading, ready);
	
  }
  return 0;
}
