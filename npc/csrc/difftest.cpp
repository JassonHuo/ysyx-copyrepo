#include <dlfcn.h>
#include <assert.h>
#include <cpu/difftest.h>
#include <difftest-def.h>
#include "sdb.h"

#define RED "\033[31m"
#define YELLOW "\033[33m"
#define BLUE "\033[34m"
#define RESET "\033[0m"
#define MEM_SIZE 134217727

void (*difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction) = NULL;
void (*difftest_regcpy)(void *dut, bool directio) = NULL;
void (*difftest_exec)(uint64_t n) = NULL;
uint32_t ref_reg[4129];
uint32_t npc_reg[4129];
uint32_t c_get_Reg(int idx);
uint32_t c_get_Pc();
uint32_t c_get_Csr(int idx);
uint32_t c_get_next_Pc();
const char *get_reg_name(int i);
extern uint32_t mem[];
extern int NPC_state;
extern bool to_device;
extern uint32_t skip_pc;

#ifdef CONFIG_MEMDIFFTEST
uint32_t ref_mem[MEM_SIZE] = {0};
uint32_t ref_mrom[0x00000fff] = {0};

void get_ref_mem()
{
  difftest_memcpy(0x80000000, (void*)ref_mem,0x7ffffff, DIFFTEST_TO_DUT);
  difftest_memcpy(0x20000000, (void*)ref_mrom, 0x00000fff, DIFFTEST_TO_DUT);
}

bool mem_check()
{
  get_ref_mem();
  int ret = !memcmp(mem, ref_mem, 0x7ffffff);
  if(!ret)
  {
	for(int i = 0; i < MEM_SIZE; i ++)
	  if(mem[i] != ref_mem[i])
		printf("0x%08x: mem: %08x | ref: %08x\n", i + 0x80000000, mem[i], ref_mem[i]);
  }
  return ret;
}
#endif

uint32_t csr_idx[] = {0x300, 0x305, 0x341, 0x342};
const char* csr_name[] = {
  "mstatus", "mtvec", "mepc", "mcause"
};
int CSR_SIZE = ARR_SIZE(csr_idx);


void get_all_Regs()
{
  for(int i = 0; i < 32; i ++)
  {
	npc_reg[i] = c_get_Reg(i);
  }
  npc_reg[32] = c_get_Pc();
//  printf("diff_npc_reg pc: %08x, to_device: %d\n", npc_reg[32], to_device);
  for(int i = 0; i < 4096; i ++)
  {
	npc_reg[i + 33] = c_get_Csr(i);
  }
}

bool reg_check()
{
  int ret = memcmp(ref_reg, npc_reg, (4096 + 33) * 4);
  if(ret)
  {
	for(int i = 0; i < 33; i ++)
	{
	  if(npc_reg[i] != ref_reg[i])
		printf(RED);
	  else if(ref_reg[i])
		printf(YELLOW);
	  if(i == 32) printf("pc     : ");
	  else printf("%-7s: ", get_reg_name(i));
	  printf("nemu: %08x | npc: %08x\n" RESET, ref_reg[i], npc_reg[i]);
	}
	for(int i = 0; i < CSR_SIZE; i ++)
	{
	  uint32_t idx = csr_idx[i] + 33;
	  if(npc_reg[idx] != ref_reg[idx])
		printf(RED);
	  else if(npc_reg[idx])
		printf(YELLOW);
	  printf("%-7s: nemu: %08x | npc: %08x\n" RESET, csr_name[i], ref_reg[idx], npc_reg[idx]);
	}
  }
  return ret == 0;
}

void init_difftest()
{
#ifdef CONFIG_DIFFTEST
  printf(BLUE "[%s %d %s] Difftest opened" RESET "\n", __FILE__, __LINE__, __func__);
  void *dl_handle = dlopen("../nemu/build/riscv32-nemu-interpreter-so", RTLD_LAZY);
  assert(dl_handle);

  difftest_memcpy = (void (*)(paddr_t, void*, size_t, bool))dlsym(dl_handle, "difftest_memcpy");
  assert(difftest_memcpy);
  difftest_regcpy = (void (*)(void*, bool))dlsym(dl_handle, "difftest_regcpy");
  assert(difftest_regcpy);
  difftest_exec = (void(*)(uint64_t))dlsym(dl_handle, "difftest_exec");
  assert(difftest_exec);

//  difftest_memcpy(0x80000000, (void*)mem, 0x7ffffff, DIFFTEST_TO_REF);
  difftest_memcpy(0x20000000, (void*)mem, 0x1000, DIFFTEST_TO_REF);
  get_all_Regs();
  difftest_regcpy((void*)npc_reg, DIFFTEST_TO_REF);
#endif
}

void difftest_skip()
{
  get_all_Regs();
  difftest_regcpy((void*)npc_reg, DIFFTEST_TO_REF);
}

void difftest_step()
{
  if(to_device)
  {
	if(c_get_Pc() == skip_pc)
	{
	  difftest_skip();
	  return;
	}
	else
	{
	  printf("test\n");
	  get_all_Regs();
	  difftest_regcpy((void*)npc_reg, DIFFTEST_TO_REF);
	  to_device = false;
	  return;
	}
  }
  difftest_exec(1);
  difftest_regcpy((void*)ref_reg, DIFFTEST_TO_DUT);
  get_all_Regs();
#ifdef CONFIG_MEMDIFFTEST
  bool ret = reg_check() && mem_check();
#else
  bool ret = reg_check();
#endif
  if(ret == false)
	NPC_state = NPC_ABORT;
}
