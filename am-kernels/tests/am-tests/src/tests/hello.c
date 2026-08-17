#include <amtest.h>

void hello() {
  for (int i = 0; i < 10; i ++) {
	/*
	int mcycle, mcycleh;
	asm volatile("csrr %0, 0xb00": "=r"(mcycle));
	asm volatile("csrr %0, 0xb80": "=r"(mcycleh));
	printf("mcycle: %x, mcycleh: %x\n", mcycle, mcycleh); 
	*/
    putstr("Hello, AM World @ " __ISA__ "\n");
  }
}
