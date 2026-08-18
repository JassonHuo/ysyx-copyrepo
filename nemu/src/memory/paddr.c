/***************************************************************************************
* Copyright (c) 2014-2024 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <memory/host.h>
#include <memory/paddr.h>
#include <device/mmio.h>
#include <isa.h>

#define YELLOW "\033[33m"
#define RESET "\033[0m"

#ifdef CONFIG_EN_MTRACE_RANGE
extern uint32_t range_start;
extern uint32_t range_end;
#endif

#if   defined(CONFIG_PMEM_MALLOC)
static uint8_t *pmem = NULL;
#else // CONFIG_PMEM_GARRAY
static uint8_t pmem[CONFIG_MSIZE] PG_ALIGN = {};
#endif
static uint8_t mrom[0x00000fff];
static uint8_t sram[0x00ffffff];

#ifdef CONFIG_MTRACE
#define MB_SIZE 100
char mb_buffer[MB_SIZE][100];
int mb_head = 0, mb_tail = 0;
char mb_tmp[100];
extern CPU_state cpu;
void mb_inQue(char *str)
{
  memcpy(mb_buffer[mb_tail], str, 100);
  mb_tail = (mb_tail + 1) % MB_SIZE;
  if(mb_head == mb_tail)
	mb_head = (mb_head + 1) % MB_SIZE;
}

void display_mt_buffer()
{
  printf(YELLOW "Memory Tracer log:\n" RESET);
  for(int i = mb_head; i != mb_tail; )
  {
	printf("%s\n", mb_buffer[i]);
	i = (i + 1) % MB_SIZE;
  }
}
#endif

uint8_t* guest_to_host(paddr_t paddr) { return pmem + paddr - CONFIG_MBASE; }
paddr_t host_to_guest(uint8_t *haddr) { return haddr - pmem + CONFIG_MBASE; }

static word_t pmem_read(paddr_t addr, int len) {
  word_t ret = 0;
  if(addr >= 0x0f000000 && addr <= 0x0fffffff)
  {
	switch(len)
	{
	  case 1:
		ret = *(sram + addr - 0x0f000000);
		break;
	  case 2:
		ret = *(uint16_t*)(sram + addr - 0x0f000000);
		break;
	  case 4:
		ret = *(uint32_t*)(sram + addr - 0x0f000000);
	}
  }
  else if(addr >= 0x20000000 && addr <= 0x20000fff)
  {
	switch(len)
	{
	  case 1:
		ret = *(mrom + addr - 0x0f000000);
		break;
	  case 2:
		ret = *(uint16_t*)(mrom + addr - 0x0f000000);
		break;
	  case 4:
		ret = *(uint32_t*)(mrom + addr - 0x0f000000);
		break;
	}
  }
  else
	ret = host_read(guest_to_host(addr), len);
//  printf("ret in pmem: %x\t", (uint32_t)ret);
  return ret;
}

static void pmem_write(paddr_t addr, int len, word_t data) {
  if(addr >= 0x0f000000 && addr <= 0x0fffffff)
  {
	switch(len)
	{
	  case 1:
		*(sram + addr - 0x0f000000) = (uint8_t)data;
		break;
	  case 2:
		*(uint16_t*)(sram + addr - 0x0f000000) = (uint16_t)data;
		break;
	  case 4:
		*(uint32_t*)(sram + addr - 0x0f000000) = (uint32_t)data;
		break;
	}
  }
  else if(addr >= 0x20000000 && addr <= 0x20000fff)
  {
	switch(len)
	{
	  case 1:
		*(mrom + addr - 0x20000000) = (uint8_t)data;
		break;
	  case 2:
		*(uint16_t*)(mrom + addr - 0x20000000) = (uint16_t)data;
		break;
	  case 4:
		*(uint32_t*)(mrom + addr - 0x20000000) = (uint32_t)data;
	}
  }
  else
	host_write(guest_to_host(addr), len, data);
}

static void out_of_bound(paddr_t addr) {
#ifdef CONFIG_ITRACE
  extern void display_iring();
  display_iring();
#endif
#ifdef CONFIG_MTRACE
  display_mt_buffer();
#endif
  panic("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD,
    addr, PMEM_LEFT, PMEM_RIGHT, cpu.pc);

}

void init_mem() {
#if   defined(CONFIG_PMEM_MALLOC)
  pmem = malloc(CONFIG_MSIZE);
  assert(pmem);
#endif
  IFDEF(CONFIG_MEM_RANDOM, memset(pmem, rand(), CONFIG_MSIZE));
  Log("physical memory area [" FMT_PADDR ", " FMT_PADDR "]", PMEM_LEFT, PMEM_RIGHT);
}

word_t paddr_read(paddr_t addr, int len) {
#ifdef CONFIG_MTRACE
#ifdef CONFIG_EN_MTRACE_RANGE
  if(addr >= range_start && addr <= range_end){
#endif
  if(len == 1)
	sprintf(mb_tmp, "0x%08x: read memory at addr 0x%08x", cpu.pc, (word_t)addr);
  else
	sprintf(mb_tmp, "0x%08x: read memory from addr 0x%08x to 0x%08x", cpu.pc, (word_t)addr, (word_t)(addr + len - 1));
  mb_inQue(mb_tmp);
#ifdef CONFIG_EN_MTRACE_RANGE
  }
#endif
#endif
  if (likely(in_pmem(addr))) return pmem_read(addr, len);
  else if (addr >= 0x0f000000 & addr <= 0x0fffffff) return sram[(addr - 0x0f000000) >> 2];
  else if (addr >= 0x20000000 & addr <= 0x20000fff) return mrom[(addr - 0x20000000) >> 2];
  IFDEF(CONFIG_DEVICE, return mmio_read(addr, len));
  out_of_bound(addr);
  return 0;
}

void paddr_write(paddr_t addr, int len, word_t data) {
#ifdef CONFIG_MTRACE
#ifdef CONFIG_EN_MTRACE_RANGE
  if(addr >= range_start && addr <= range_end){
#endif
  if(len == 1)
	sprintf(mb_tmp, "0x%08x write memory at addr 0x%08x", cpu.pc, (word_t)addr);
  else
	sprintf(mb_tmp, "0x%08x write memory from addr	0x%08x to 0x%08x", cpu.pc, (word_t)addr, (word_t)(addr + len - 1));
  mb_inQue(mb_tmp);
#ifdef CONFIG_EN_MTRACE_RANGE
  }
#endif
#endif
  if (likely(in_pmem(addr)) || (addr >= 0x0f000000 && addr <= 0x0fffffff) || (addr >= 0x20000000 && addr <= 0x20000fff)) { pmem_write(addr, len, data); return; }
  IFDEF(CONFIG_DEVICE, mmio_write(addr, len, data); return);
  out_of_bound(addr);
}
