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

void clear_bss()
{
  volatile char *p = NULL;
  for(p = _bss_start; p <= _bss_end; p ++)
	*p = 0;
}

/*
uint32_t flash_read(uint32_t addr)
{
  volatile uint8_t *base = (volatile uint8_t*)0x10001000;
  volatile uint32_t *tx = (uint32_t*)base;
  volatile uint32_t *rx = tx;
  volatile uint32_t *div = (uint32_t*)(base + 0x14);
  volatile uint32_t *ctrl = (uint32_t*)(base + 0x10);
  volatile uint32_t *ss = (uint32_t*)(base + 0x18);
  while (*ctrl & 0x100);
  *ctrl = 0b10001001000000;
  *tx = (0x03 << 24) | (addr & 0xffffff);
  *div = 1;
  *ss = 1;
  *ctrl |= 1 << 8;
  while (*ctrl & 0x100);
  return *rx;
}
*/

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
  while(~LSR & 0x20) LSR = base[5];
  outb(0x10000000,ch);
}

void halt(int code) {
  asm volatile("mv a0, %0; ebreak": :"r"(code));
  while(1);
}

void _trm_init() {
  data_copy();
  clear_bss();
  uint8_t LCR = 0;
  volatile uint8_t* base = (volatile uint8_t *)0x10000000;
  LCR = base[3];
  base[3] = LCR | 0x80;
  base[0] = 1;
  base[1] = 0;
  base[3] = LCR;
  int ret = main(mainargs);
  halt(ret);
}
