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

#include <isa.h>
#include <cpu/cpu.h>
#include <difftest-def.h>
#include <memory/paddr.h>


__EXPORT void difftest_memcpy(paddr_t addr, void *buf, size_t n, bool direction) {
  if(direction == DIFFTEST_TO_DUT)
	for(int i = 0; i < n; i ++)
	{
	  *(char*)(buf + i) = paddr_read(addr + i, 1);
	}
  else if(direction == DIFFTEST_TO_REF)
  {
	for(int i = 0; i < n; i ++)
	{
	  paddr_write(addr + i, 1, *(char*)(buf + i));
//	  printf("write data: %08x to %08x, read: %08x\n", *(uint8_t*)(buf + i), addr + i, paddr_read(addr + i, 1));
//  	  printf("copy memory at %08x\n", addr + i);
	}
  }
  else
	assert(0);
}

__EXPORT void difftest_memtodut(void *dut, void *ref, size_t n)
{
  memcpy(dut, ref, n);
}

__EXPORT void difftest_regcpy(void *dut, bool direction) {
  char *p = (char*)&cpu;
  if(direction == DIFFTEST_TO_DUT)
  {
	memcpy(dut, p, DIFFTEST_REG_SIZE);
	memcpy(dut + DIFFTEST_REG_SIZE, p + DIFFTEST_REG_SIZE, 4096 * 4);
  }
  else if(direction == DIFFTEST_TO_REF)
  {
	memcpy(p, dut, DIFFTEST_REG_SIZE);
	memcpy(p + DIFFTEST_REG_SIZE, dut + DIFFTEST_REG_SIZE, 4096 * 4);
  }
  else
	assert(0);
}

__EXPORT void difftest_exec(uint64_t n) {
//  ref_difftest_exec(n);
//  printf("nemu exec onece");
  cpu_exec(n);
}

__EXPORT void difftest_raise_intr(word_t NO) {
//  ref_difftest_raise_intr(NO);
}

__EXPORT void difftest_init(int port) {
  void init_mem();
  init_mem();
  /* Perform ISA dependent initialization. */
  init_isa();
}
