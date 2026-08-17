#include <klib.h>
#include <am.h>

void mem_write(int bits)
{
  int step = bits / 8;
  for(void *addr = heap.start; addr < heap.start + 256; addr += step)
  {
	switch(bits)
	{
	  case(8):  *(uint8_t*)addr = (uint8_t)(uintptr_t)addr;break;
	  case(16): *(uint16_t*)addr = (uint16_t)(uintptr_t)addr;break;
	  case(32): *(uint32_t*)addr = (uint32_t)(uintptr_t)addr;break;
	  case(64): *(uint64_t*)addr = (uint64_t)(uintptr_t)addr;break;
	}
  }
}

void mem_check(int bits)
{
  int step = bits / 8;
  for(void* addr = heap.start; addr < heap.start + 256; addr += step)
  {
	switch(bits)
	{
	  case(8):  
		if(*(uint8_t*)addr != (uint8_t)(uintptr_t)addr)
		  halt(1);
		break;
	  case(16): 
		if(*(uint16_t*)addr != (uint16_t)(uintptr_t)addr)
		  halt(1);
		break;
	  case(32): 
		if(*(uint32_t*)addr != (uint32_t)(uintptr_t)addr)
		  halt(1);
		break;
	  case(64): 
		if(*(uint64_t*)addr != (uint64_t)(uintptr_t)addr)
		  halt(1);
		break;
	}
  }
}

int main()
{
  for(int bits = 8; bits <= 64; bits *= 2)
  {
	mem_write(bits);
	mem_check(bits);
  }
  halt(0);
}
