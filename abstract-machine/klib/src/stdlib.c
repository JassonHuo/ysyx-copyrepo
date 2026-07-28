#include <klib.h>
#include <klib-macros.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)
static unsigned long int next = 1;

int rand(void) {
  // RAND_MAX assumed to be 32767
  next = next * 1103515245 + 12345;
  return (unsigned int)(next/65536) % 32768;
}

void srand(unsigned int seed) {
  next = seed;
}

int abs(int x) {
  return (x < 0 ? -x : x);
}

int atoi(const char* nptr) {
  int x = 0;
  while (*nptr == ' ') { nptr ++; }
  while (*nptr >= '0' && *nptr <= '9') {
    x = x * 10 + *nptr - '0';
    nptr ++;
  }
  return x;
}

//static uint8_t* addr = NULL;

void *malloc(size_t size) {
  // On native, malloc() will be called during initializaion of C runtime.
  // Therefore do not call panic() here, else it will yield a dead recursion:
  //   panic() -> putchar() -> (glibc) -> malloc() -> panic()
#if !(defined(__ISA_NATIVE__) && defined(__NATIVE_USE_KLIB__))
//  panic("Not implemented");
  static uint8_t *addr = NULL;
  if(addr == NULL)
  {
	addr = (uint8_t*)heap.start;
//	addr = (uint8_t*)(((uintptr_t)addr + 7) & ~7);
	addr = (uint8_t*)(((uint32_t)addr + 7) & ~7);
  }
  if(size == 0)
	return NULL;
  uint8_t *ret_addr = addr;
  size = (size + 7) & ~7;
  if(addr + size > (uint8_t*)heap.end)
	return NULL;
  addr += size;
  return ret_addr;
#else
  extern void* __libc_malloc(size_t);
  return __libc_malloc(size);
#endif
  return NULL;
}

void free(void *ptr) {
}

#endif
