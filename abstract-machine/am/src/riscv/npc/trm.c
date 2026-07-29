#include <am.h>
#include <klib-macros.h>
#include <riscv/riscv.h>
#include <klib.h>

extern char _heap_start;
int main(const char *args);

extern char _pmem_start;
#define PMEM_SIZE (128 * 1024 * 1024)
#define PMEM_END  ((uintptr_t)&_pmem_start + PMEM_SIZE)

/*
#define RED "\033[31m"
#define GREEN "\033[32m"
#define RESET "\033[0m"
*/

Area heap = RANGE(&_heap_start, PMEM_END);
static const char mainargs[MAINARGS_MAX_LEN] = TOSTRING(MAINARGS_PLACEHOLDER); // defined in CFLAGS

void putch(char ch) {
  outb(0x10000000,ch);
}

void halt(int code) {
  asm volatile("mv a0, %0; ebreak": :"r"(code));
  while(1);
}

void _trm_init() {
//  uint32_t mcycle, mcycleh;
 // asm volatile("csrr %0, 0xb00;": "=r"(mcycle));
  //asm volatile("csrr %0, 0xb80;": "=r"(mcycleh));
  //printf("mcycle: %d, mcycleh: %d\n", mcycle, mcycleh);
  int ret = main(mainargs);
  halt(ret);
}
