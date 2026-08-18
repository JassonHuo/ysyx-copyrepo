#include <am.h>
#include <klib-macros.h>
#include <riscv/riscv.h>
#include <klib.h>

extern char _heap_start;
extern char _heap_end;
extern char _data_start[];
extern char _data_load_start[];
extern char _data_end[];
extern char _data_size[];
extern char _bss_start[];
extern char _bss_end[];

void data_copy()
{
  if(_data_start != _data_load_start)
	memcpy(_data_start, _data_load_start, (size_t)_data_size);
}

int main(const char *args);

extern char _pmem_start;
//#define PMEM_SIZE (128 * 1024 * 1024)
#define PMEM_SIZE (8 * 1024)
#define PMEM_END  ((uintptr_t)&_pmem_start + PMEM_SIZE)

/*
#define RED "\033[31m"
#define GREEN "\033[32m"
#define RESET "\033[0m"
*/

//Area heap = RANGE(&_heap_start, PMEM_END);
Area heap = RANGE(&_heap_start, &_heap_end);
static const char mainargs[MAINARGS_MAX_LEN] = TOSTRING(MAINARGS_PLACEHOLDER); // defined in CFLAGS

void putch(char ch) {
  volatile uint8_t* base = (volatile uint8_t*)0x10000000;
  uint8_t LSR = base[5];
  while(~LSR & 0x10);
  outb(0x10000000,ch);
}

void halt(int code) {
  asm volatile("mv a0, %0; ebreak": :"r"(code));
  while(1);
}

void _trm_init() {
  data_copy();
  /*
  uint8_t LCR = 0;
  volatile uint8_t* base = (volatile uint8_t *)0x10000000;
  LCR = base[3];
  base[3] = LCR | 0x80;
  base[0] = 1;
  base[1] = 0;
  base[3] = LCR;
  */
  /*
  asm volatile("lb %0, 3(%1)": "=r"(LCR): "r"(base));
  LCR = LCR | 0x80;
  asm volatile("sb %0, 3(%1)": "r"(LCR): "r"(base));
  asm volatile("sb %0, 0(%1)": "r"(1): "r"(base));
  */
  int ret = main(mainargs);
  halt(ret);
}
