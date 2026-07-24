#include <dlfcn.h>
#include <assert.h>
#include <cpu/difftest.h>
#include <difftest-def.h>
#include "sdb.h"

void (*difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction) = NULL;
void (*difftest_regcpy)(void *dut, bool directio) = NULL;
void (*difftest_exec)(uint64_t n) = NULL;
uint32_t ref_reg[DIFFTEST_REG_SIZE];
uint32_t npc_reg[DIFFTEST_REG_SIZE];
uint32_t c_get_Reg(int idx);
uint32_t c_get_Pc();
extern uint32_t mem[];
extern int NPC_state;

void get_all_Regs()
{
  for(int i = 0; i < DIFFTEST_REG_SIZE - 1; i ++)
  {
	npc_reg[i] = c_get_Reg(i);
  }
  npc_reg[DIFFTEST_REG_SIZE - 1] = c_get_Pc();
}

bool reg_check()
{
  for(int i = 0; i < DIFFTEST_REG_SIZE - 1; i ++)
	if(npc_reg[i] != ref_reg[i])
	  return false;
  return true;
}

void init_difftest()
{
  void *dl_handle = dlopen("../nemu/build/riscv32-nemu-interpreter-so", RTLD_LAZY);
  assert(dl_handle);

  difftest_memcpy = (void (*)(paddr_t, void*, size_t, bool))dlsym(dl_handle, "difftest_memcpy");
  assert(difftest_memcpy);
  difftest_regcpy = (void (*)(void*, bool))dlsym(dl_handle, "difftest_regcpy");
  assert(difftest_regcpy);
  difftest_exec = (void(*)(uint64_t))dlsym(dl_handle, "difftest_exec");
  assert(difftest_exec);

  difftest_memcpy(0x80000000, (void*)mem, 0x7ffffff, DIFFTEST_TO_REF);
  printf("test\n");
  get_all_Regs();
  difftest_regcpy((void*)npc_reg, DIFFTEST_TO_REF);
}

void difftest_step()
{
  difftest_exec(1);
  difftest_regcpy((void*)ref_reg, DIFFTEST_TO_DUT);
  get_all_Regs();
  bool ret = reg_check();
  if(!ret)
	NPC_state = NPC_ABORT;
}
