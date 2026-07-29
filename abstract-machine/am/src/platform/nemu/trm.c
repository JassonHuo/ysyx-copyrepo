#include <am.h>
#include <nemu.h>
//#include <stdio.h>

extern char _heap_start;
int main(const char *args);

Area heap = RANGE(&_heap_start, PMEM_END);
static const char mainargs[MAINARGS_MAX_LEN] = TOSTRING(MAINARGS_PLACEHOLDER); // defined in CFLAGS

void putch(char ch) {
//  printf("out char: %c\n", ch);
  outb(SERIAL_PORT, ch);
}

void halt(int code) {
  nemu_trap(code);

  // should not reach here
  while (1);
}

void _trm_init() {
  uint32_t mcycle, mcycleh
  asm volatile("csrr %0, 0xb00": "=r"(mcycle));
  asm volatile("csrr %0, 0xb80": "=r"(mcycleh));
  printf("mcycle: %d, mcycleh: %d\n", mcycle, mcycleh);
  int ret = main(mainargs);
  asm volatile("csrr %0, 0xb00": "=r"(mcycle));
  asm volatile("csrr %0, 0xb80": "=r"(mcycleh));
  printf("mcycle: %d, mcycleh: %d\n", mcycle, mcycleh);
  halt(ret);
}
