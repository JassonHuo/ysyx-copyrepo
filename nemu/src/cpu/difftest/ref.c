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

//extern void (*ref_difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction);
//extern void (*ref_difftest_regcpy)(void *dut, bool direction);
//extern void (*ref_difftest_exec)(uint64_t n);
//extern void (*ref_difftest_raise_intr)(uint64_t NO);

__EXPORT void difftest_memcpy(paddr_t addr, void *buf, size_t n, bool direction) {
  if(direction == DIFFTEST_TO_DUT)
	for(int i = 0; i < n; i ++)
	  *(char*)(buf + i) = paddr_read(addr + i, 1);
  else if(direction == DIFFTEST_TO_REF)
	for(int i = 0; i < n; i ++)
	  paddr_write(addr + i, 1, *(char*)(buf + i));
  else
	assert(0);
//  ref_difftest_memcpy(addr, buf, n, direction);
}

__EXPORT void difftest_regcpy(void *dut, bool direction) {
//  ref_difftest_regcpy(dut, direction);
  word_t *p = (word_t*)&cpu;
  printf("test\n");
  if(direction == DIFFTEST_TO_DUT)
  {
	for(int i = 0; i < DIFFTEST_REG_SIZE; i ++)
	{
	  printf("to dut cpu: %d, dut: %d\n", *(p + i), *(((word_t*)dut) + i));
	  *(((word_t*)dut) + i) = *(p + i);
	}
//	  cpu.gpr[i] = ctx->XPR[i];
//	cpu.pc = ctx->pc;
  }
  else if(direction == DIFFTEST_TO_REF)
  {
	for(int i = 0; i < DIFFTEST_REG_SIZE; i ++)
	{
	  printf("to ref cpu: %d, dut: %d\n", *(p + i), *(((word_t*)dut) + i));
	  *(p + i) = *(((word_t*)dut) + i);
	}
  }
  else
	assert(0);
}

__EXPORT void difftest_exec(uint64_t n) {
//  ref_difftest_exec(n);
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
