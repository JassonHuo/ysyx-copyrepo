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

#ifdef CONFIG_ETRACE
#define ET_SIZE 100
#define YELLOW "\033[33m"
#define RESET "\033[0m"
static char excep_buffer[ET_SIZE][100];
static int et_head = 0;
static int et_tail = 0;

static void et_inQue(char *str)
{
  strcpy(excep_buffer[et_tail], str);
  et_tail = (et_tail + 1) % ET_SIZE;
  if(et_tail == et_head) 
	et_head = (et_head + 1) % ET_SIZE;
}

void display_et()
{
  printf(YELLOW "Exception trace log: \n" RESET);
  for(int i = et_head; i != et_tail; )
  {
	printf("%s\n", excep_buffer[i]);
	i = (i + 1) % ET_SIZE;
  }
}
#endif

word_t isa_raise_intr(word_t NO, vaddr_t epc) {
  /* TODO: Trigger an interrupt/exception with ``NO''.
   * Then return the address of the interrupt/exception vector.
   */
  cpu.csr[0x341] = epc;	  //mepc
  cpu.csr[0x342] = NO;	  //mcause	 
#ifdef CONFIG_ETRACE
  char tmp[100] = "";
  sprintf(tmp, "Trap happened, mepc: %08x, mcause: %d, targetPc: %08x", epc, NO, cpu.csr[0x305]);
  et_inQue(tmp);
#endif
  return cpu.csr[0x305];  //mtvec
}

word_t isa_query_intr() {
  return INTR_EMPTY;
}
