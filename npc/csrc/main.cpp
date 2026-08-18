#include <stdio.h>
//#include <Vtop.h>
#include <VysyxSoCFull.h>
#include <verilated.h>
#include <stdint.h>
#include "svdpi.h"
//#include "Vtop__Dpi.h"
#include "VysyxSoCFull__Dpi.h"
#include <limits.h>
#include <fstream>
#include <cstring>
#include <iostream>	
#include <sstream>
#include <time.h>
#include <sys/time.h>
#include "sdb.h"
#include <capstone/capstone.h>
#include <verilated_vcd_c.h>
//#include "Vtop___024root.h"
#include "VysyxSoCFull___024root.h"
#include <signal.h>
#include <unistd.h>

#define EBREAK 0x00100073 
#define MEM_SIZE 134217727
#define GREEN "\033[32m"
#define RED "\033[31m"
#define BLUE "\033[34m"
#define YELLOW "\033[33m"
#define RESET "\033[0m"
#define IB_SIZE 16
#define MB_SIZE 100
#define FB_SIZE 300
#define BUFFER_IRING 0
#define BUFFER_MEMORY 1
#define BUFFER_FUNCTION 2

#define cat(a, b) a##b
#define CONCAT(x, y) cat(x, y)
#define CSRCAT(x) CONCAT(CSR_PUBLIC_PATH, x)
#define CSR_PUBLIC_PATH top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__csr0__DOT__

#define TRACE(a) CONFIG_##a##TRACE
#define CONFIG_TRACES  \
  defined(TRACE(I)) || \
  defined(TRACE(M)) || \
  defined(TRACE(F))

#define FT_DISPLAY do{\
  int p = 0;\
  p += sprintf(tmp, "%08x:-", pc);\
  for(int i = 0; i < layer; i ++) p += sprintf(tmp + p, "--");\
}while(0)

uint32_t mem[MEM_SIZE] = {0};
static VerilatedContext *contextp = new VerilatedContext;
static TOP_NAME *top = new TOP_NAME;
VerilatedVcdC* tfp = new VerilatedVcdC;

static struct timeval tv;
static uint8_t *serial_base = NULL;
static uint64_t start_time;
static uint32_t before_pc;

void sdb_mainloop();
char *march_func(uint32_t addr);
#ifdef CONFIG_DIFFTEST
void difftest_step();
void init_difftest();
#endif
int NPC_state = NPC_STOP;
bool to_device = false;
uint32_t skip_pc = 0;

#ifdef CONFIG_TRACES

#define INQUE(a, b) do{\
  memcpy(a##_buffer[b##_tail], str, 100);\
  b##_tail = (b##_tail + 1) % b##_SIZE;\
  if(b##_tail == b##_head)\
  b##_head = (b##_head + 1) % b##_SIZE;\
}while(0)

#define DISPLAY(a, b) do{\
  for(int i = b##_head; i != b##_tail;)\
  {\
	if(i == (b##_tail - 1 + b##_SIZE) % b##_SIZE)\
		printf(RED " -->");\
	printf("%s" RESET "\n", a##_buffer[i]);\
	i = (i + 1) % b##_SIZE;\
  }\
}while(0)

#endif

#ifdef CONFIG_ITRACE
static char iring_buffer[IB_SIZE][100];
static int IB_head = 0; 
static int IB_tail = 0;

static void ib_inQue(char *str)
{
  INQUE(iring, IB);
}

static void display_ib()
{
  DISPLAY(iring, IB);
}
#endif

#ifdef CONFIG_MTRACE
static char memory_buffer[MB_SIZE][100];
static int MB_head = 0;
static int MB_tail = 0;

static void mb_inQue(char *str)
{
 /*
  memcpy(memory_buffer[mb_tail], str, 100);
  mb_tail = (mb_tail + 1) % MB_SIZE;
  */
  INQUE(memory, MB);
}

static void display_mb()
{
  /*
  for(int i = mb_head; i != mb_tail; i ++)
  {
	printf("%s\n", memory_buffer[i]);
	i = (i + 1) % MB_SIZE;
  }
  */
  DISPLAY(memory, MB);
}
#endif

#ifdef CONFIG_FTRACE
static char function_buffer[FB_SIZE][500];
static int FB_head = 0;
static int FB_tail = 0;
static int layer = 0;
static void fb_inQue(char *str)
{
  INQUE(function, FB);
}

static void display_fb()
{
//  DISPLAY(function, FB);
  for(int i = FB_head; i != FB_tail; )
  {
	printf("%s\n", function_buffer[i]);
	i = (i + 1) % FB_SIZE;
  }
}
#endif


void init_disasm();
extern "C" void do_quitcheck();

static void init_file(char *args);
static void init_batch_mode(char *args);
void init_elf(char *args);

int batch_mode_open();
uint32_t c_get_Pc();
uint32_t c_get_Reg(int idx);

FILE *fp = NULL;


static struct {
  const char *signal;
  int arg_num;
  void (*init)(char *);
} arg_table[] = {
  {"-f", 1, init_file},
  {"-b", 0, init_batch_mode},
  {"-e", 1, init_elf},
};

int ARG_SIZE = ARR_SIZE(arg_table);

void read_arg(int argc, char **args)
{
  if(argc == 1)
  {
	printf("Arg num Error\n");
	exit(1);
  }
  for(int i = 1; i < argc; i++)
  {
	/*
	for(int m = 0; m < argc; m ++)
	  printf("%s\n", args[m]);
	  */
	for(int j = 0; j < ARG_SIZE; j++)
	{
	  if(!strcmp(args[i], arg_table[j].signal))
	  {

		char *arg_arr = NULL;
		if(arg_table[j].arg_num)
		  arg_arr = (char*)malloc(arg_table[j].arg_num * 200 * sizeof(char));
		int p = 0;
//		printf("%d %d\n", i, j);
//		printf("%s %s\n", args[i], arg_table[j].signal);
		for(int k = i + 1; k <= i + arg_table[j].arg_num; k++)
		{
//		  printf("%d\n", i);
//		  printf("%d\n", k);
		  p += sprintf(arg_arr, "%s,", args[k]);
		}
		arg_table[j].init(arg_arr);
		free(arg_arr);
		i += arg_table[j].arg_num;
		break;
	  }
	}
  }
}

void init_file(char *args)
{
  char *file_name = strtok(args, ",");
  fp = fopen(file_name, "rb");
  if(fp == NULL)
  {
	printf("File open Error %s\n", file_name);
	exit(1);
  }
  int mem_top = 0;
  while(fread(mem + mem_top++, 4, 1, fp));
}

void init_batch_mode(char *args)
{
//  int batch_mode_open();
  batch_mode_open();
}


void ebreak()
{
//  ebreak_happened = true;
  /*
  printf("[%s:%d %s] npc: ", __FILE__, __LINE__, __func__);
  if(!top->a0)
	printf(GREEN "HIT GOOD TRAP " RESET);
  else
	printf(RED "HIT BAD TRAP " RESET);
  printf("at pc = %08x\n", top->pc);
  */
  NPC_state = NPC_END;
}

static inline void time_init()
{
  gettimeofday(&tv, NULL);
  start_time = tv.tv_sec * 1000000 + tv.tv_usec;
}

static inline uint64_t get_time()
{
  gettimeofday(&tv, NULL);
  return tv.tv_sec * 1000000 + tv.tv_usec - start_time;
}

extern "C" void flash_read(int32_t addr, int32_t *data) { assert(0); }
extern "C" void mrom_read(int32_t addr, int32_t *data) { *data = mem[(addr - 0x20000000) >> 2]; }

extern "C" void TO_device()
{
  to_device = true;
  skip_pc = c_get_Pc();
}

extern "C" int pmem_read(int addr)
{
#ifdef CONFIG_MTRACE
  char tmp[100];
#ifdef MTRACE_RANGE
  if(addr >= MTRACE_MIN && addr <= MTRACE_MAX)
  {
#endif
  sprintf(tmp, "\t0x%08x: pmem_read  at %08x", c_get_Pc(), addr);
  mb_inQue(tmp);
#ifdef MTRACE_RANGE
  }
#endif
#endif

  if(addr == 0x02000000) {to_device = true; skip_pc = c_get_Pc(); return 0;}
  else if(addr == 0x10000048) {to_device = true;skip_pc = c_get_Pc(); return (uint32_t)get_time();}
  else if(addr == 0x1000004c){to_device = true;  skip_pc = c_get_Pc(); return get_time() >> 32;}
  else if(addr >= 0x80000000 && addr <= 0x87ffffff) return mem[((uint32_t)addr - 0x80000000) >> 2];
  else 
  {
#ifdef CONFIG_MTRACE
	display_mb();
#endif
	printf("read: %08x out of range\n", addr);
	NPC_state = NPC_ABORT;
	return 1;
  }
}

extern "C" void pmem_write(int waddr, int wdata, char wmask)
{
  //if(top->clock)
  {
#ifdef CONFIG_MTRACE
	char tmp[100];
#ifdef MTRACE_RANGE
	if(waddr >= MTRACE_MIN && waddr <= MTRACE_MAX)
	{
#endif
	sprintf(tmp, "\t0x%08x: pmem_write at %08x", c_get_Pc(), waddr);
	mb_inQue(tmp);
#ifdef MTRACE_RANGE
	}
#endif
#endif
	if(waddr == 0x10000048) {to_device = true; skip_pc = c_get_Pc(); return;}
	else if(waddr == 0x1000004c) {to_device = true; skip_pc = c_get_Pc(); return;}
	else if(waddr == 0x10000000)
	{
	  to_device = true;
      putchar(wdata);
	  skip_pc = c_get_Pc(); 
	  fflush(stdout);
	}
	else if(waddr >= 0x80000000 && waddr <= 0x87ffffff)
	{
	  uint32_t tmp = mem[((uint32_t)waddr - 0x80000000) >> 2];
	  uint32_t byte_mask = 0;
	  uint32_t mask = 0;
	  for (int byte = 0; byte < 4; byte ++)
	  {
		byte_mask = wmask % 2;
		wmask /= 2;
		if(byte_mask)
		  mask = mask | 0xFF << byte * 8;
	  }
	  uint32_t tmp_mask = mask;
	  while(tmp_mask % 2 == 0)
	  {
		if(!tmp_mask)
		  break;
		tmp_mask = tmp_mask >> 4;
	  }
	  wdata = wdata & tmp_mask;
	  while(tmp_mask != mask)
	  {
		tmp_mask = tmp_mask << 4;
		wdata = wdata << 4;
	  }
	  tmp = (tmp & ~mask) | (wdata & mask);
	  mem[((uint32_t)waddr - 0x80000000) >> 2] = tmp;
	}
	else
	{
#ifdef CONFIG_MTRACE
	  display_mb();
#endif
	  printf("write: %08x out of range\n", waddr);
	  NPC_state = NPC_ABORT;
	  tfp->close();
	}
  }
}

extern "C" void do_quitcheck()
{
  printf("[%s:%d %s] npc: ", __FILE__, __LINE__, __func__);
  if(NPC_state == NPC_ABORT)
  {
	printf(RED "ABORT " RESET);
  }
  else if(NPC_state == NPC_INTERUPT)
  {
	printf(YELLOW "INTERUPT" RESET);
  }
  else if(!c_get_Reg(10))
	printf(GREEN "HIT GOOD TRAP " RESET);
  else
	printf(RED "HIT BAD TRAP " RESET);
  printf("at pc = %08x\n", before_pc);
//  if(NPC_state == NPC_ABORT)
//	exit(1);
}

extern "C" void npc_abort()
{
  NPC_state = NPC_ABORT;
}

uint32_t hex2num(std::string &hex)
{
  return std::stoul(hex, nullptr, 16);
}


uint32_t c_get_Reg(int idx)
{
  /*
  extern int get_Reg(int idx);
  assert(top != NULL);
  assert(svGetScopeFromName("TOP") != NULL);
  svSetScope(svGetScopeFromName("TOP.top.gpr0.Gpr"));
  return (uint32_t)get_Reg(idx);
  */
  if(idx >= 0 && idx <= 15)
	return top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__gpr0__DOT__Gpr__DOT__rf[idx];
  return 0;
}

uint32_t c_get_Inst()
{
  /*
  extern int get_Inst();
  svSetScope(svGetScopeFromName("TOP.top.idu0"));
  return (uint32_t)get_Inst();
  */
  return top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ifu0__DOT__inst;
}

uint32_t c_get_Pc()
{
  /*
  extern int get_Pc();
  svSetScope(svGetScopeFromName("TOP.top.ifu0.pc0"));
  return (uint32_t)get_Pc();
  */
  return top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__ifu0__DOT__pc0__DOT__pc;
}

uint32_t c_get_Csr(int idx)
{
  /*
  extern int get_Csr(int idx);
  svSetScope(svGetScopeFromName("TOP.top.csr0"));
  return (uint32_t)get_Csr(idx);
  */
  if(idx == 0x341)
	return CSRCAT(mepc);
  else if(idx == 0x342)
	return CSRCAT(mcause);
  else if(idx == 0x300)
	return CSRCAT(mstatus);
  else if(idx == 0x305)
	return CSRCAT(mtvec);
  else
	return 0;
}


void run_cycle(uint64_t n)
{
  bool output_pc = false;
  if(n != (uint64_t)-1)
	output_pc = true;
  for(uint64_t i = 0; i < n && NPC_state != NPC_END; i ++)
  {
#ifdef CONFIG_ITRACE
	uint32_t isa_inst = c_get_Inst();
	uint32_t pc = c_get_Pc();
	int p = 0;
	uint8_t* inst = (uint8_t*)&isa_inst;
	void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
	char inst_str[90];
	char tmp[100];
	p += sprintf(inst_str, "0x%08x: ", pc);
	disassemble(inst_str + p, 100, (uint64_t)pc, inst, 4);
	for(int i = 3; i >= 0; i --)
	  p += sprintf(inst_str + strlen(inst_str), "%02x ", inst[i]);
	sprintf(tmp, "\t%s", inst_str);
	if(top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__wbu0__DOT__done)
	  ib_inQue(tmp);
	if(output_pc)
	  printf("%s\n", inst_str);
#endif

#ifdef CONFIG_FTRACE
	uint32_t full_inst;
#ifdef CONFIG_ITRACE
	full_inst = isa_inst;
#else
	full_inst = c_get_Inst();
#endif
	uint8_t opcode = full_inst & 0x7f;
	if(opcode == 0x6f || opcode == 0x67)
	{
	  uint8_t rd = (full_inst >> 7) & 0x1f;
	  uint8_t rs1 = (full_inst >> 15) & 0x1f;
	  int32_t imm;
	  char tmp[500];
	  if(opcode == 0x6f && rd == 1)
	  {
		imm = (((int32_t)full_inst >> 30) << 20) | 
		  (((full_inst >> 12) & 0xff) << 12) | 
		  (((full_inst >> 20) & 0x1) <<11) | 
		  (((full_inst >> 21) & 0x3ff) << 1);
		uint32_t tar_addr = pc + imm;
		char *func_name = march_func(tar_addr);
		int p = 0;
		p += sprintf(tmp, "%08x:-", pc);
		for(int i = 0; i < layer; i ++) p += sprintf(tmp + p, "--");
		sprintf(tmp + p, "call[%s@%08x]", func_name, tar_addr);
		free(func_name);
		layer ++;
		fb_inQue(tmp);
	  }
	  else if(opcode == 0x67)
	  {
		imm = (int32_t)full_inst >> 20;
		if(imm == 0 && rd == 0 && rs1 == 1)
		{
		  uint32_t tar_addr = c_get_Reg(rs1);
		  char *func_name = march_func(tar_addr);
		  layer--;
		  int p = 0;
		  p += sprintf(tmp, "%08x:-", pc);
		  for(int i = 0; i < layer; i ++) p += sprintf(tmp + p, "--");
		  sprintf(tmp + p, "ret[%08x]", tar_addr);
		  free(func_name);
		  fb_inQue(tmp);
		}
		else if(rd == 1)
		{
		  uint32_t tar_addr = c_get_Reg(rs1) + imm;
		  char *func_name = march_func(tar_addr);
		  int p = 0;
		  p += sprintf(tmp, "%08x:-", pc);
		  for(int i = 0; i < layer; i ++) p += sprintf(tmp + p, "--");
		  layer++;
		  sprintf(tmp + p, "call[%s@%08x]", func_name, tar_addr);
		  free(func_name);
		  fb_inQue(tmp);
		}
	  }
	}
#endif
	top->clock = 0;
	top->eval();
//	if(NPC_state == NPC_END || NPC_state == NPC_ABORT)break;
#ifdef CONFIG_WAVE
	tfp->dump(contextp->time());
	contextp->timeInc(1);
	tfp->flush();
#endif
	before_pc = c_get_Pc();
	top->clock = 1;
	top->eval();
#ifdef CONFIG_WAVE
	tfp->dump(contextp->time());
	contextp->timeInc(1);
	tfp->flush();
#endif
#ifdef CONFIG_DIFFTEST
	static bool done;
	static bool pre_done;
	pre_done = done;
	done = top->rootp->ysyxSoCFull__DOT__asic__DOT__cpu__DOT__cpu__DOT__wbu0__DOT__done;
	if(pre_done & ~done)
	  difftest_step();
#endif
	if(NPC_state != NPC_RUNNING)
	{
#ifdef CONFIG_ITRACE
	  display_ib();
#endif
	  return;
	}
  }
}

void handle_sigint(int sig)
{
  NPC_state = NPC_INTERUPT;
}

int main(int argc, char** argv) {
  signal(SIGINT, handle_sigint);
  Verilated::commandArgs(argc, argv);
#ifdef CONFIG_WAVE
  Verilated::traceEverOn(true);
  top->trace(tfp, 99);
  tfp->open("wave.vcd");
  printf(BLUE "[%s %d %s] Open wave dump to wave.vcd" RESET "\n", __FILE__, __LINE__, __func__);
#endif
  printf(BLUE "Open physical memory area [0x80000000, 0x87ffffff]" RESET "\n");
  printf(BLUE "Open device serial at [0x10000000, 0x10000004]" RESET "\n");
  printf(BLUE "Open device rtc at [0x10000048, 0x1000004f]" RESET "\n");

  read_arg(argc, argv);
  init_disasm();

  top->reset = 1;
  for(int i = 0; i < 10; i ++)
  {
	top->clock = 0;
	top->eval();
	top->clock = 1;
	top->eval();
  }
  top->reset = 0;

  time_init();
#ifdef CONFIG_DIFFTEST
  init_difftest();
#endif
  sdb_mainloop();
  delete top;
#ifdef CONFIG_FTRACE
  display_fb();
#endif
#ifdef CONFIG_WAVE
  tfp->close();
#endif
  if(NPC_state == NPC_QUIT)
	return 0;
  do_quitcheck();
//  return c_get_Reg(10);
  return (NPC_state == NPC_ABORT | c_get_Reg(10));
}
