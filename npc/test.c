#include <klib.h>
#include <am.h>

int main()
{
  int a = 5;
  asm volatile("csrw, 0x305, %0": : "r"(a));
  return 0;
}
