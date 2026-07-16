#include <am.h>
#include <klib-macros.h>

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
}

void halt(int code) {
  /*
  if(!code)
  {
	printf(GREEN "HIT GOOD TRAP" RESET "\n");
  }
  else
  {
	printf(RED "HIT BAD TRAP" RESET "\n");
  }
  */
  asm volatile("mv a0, %0; ebreak": :"r"(code));
  while(1);
}

void _trm_init() {
  int ret = main(mainargs);
  halt(ret);
}
