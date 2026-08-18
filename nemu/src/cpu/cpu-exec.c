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

#include <cpu/cpu.h>
#include <cpu/decode.h>
#include <cpu/difftest.h>
#include <locale.h>
#include <elf.h>
#include <assert.h>

/* The assembly code of instructions executed is only output to the screen
 * when the number of instructions executed is less than this value.
 * This is useful when you use the `si' command.
 * You can modify this value as you want.
 */
#define MAX_INST_TO_PRINT 10
#define IRING_SIZE 100
#define FB_SIZE 300

#define RED "\033[31m"
#define YELLOW "\033[33m"
#define RESET "\033[0m"

#ifdef CONFIG_FTRACE
typedef struct FUNC
{
  uint32_t addr;
  int size;
  char func_name[30];
} FUNC;
FILE *elf_fp = NULL;

FUNC *functs = NULL;
int fun_top = 0;
char ftrace_buffer[FB_SIZE][100];
int fb_head = 0;
int fb_tail = 0;
static int layer = 0;

void fb_inQue(char *str)
{
  memcpy(ftrace_buffer[fb_tail], str, 100);
  fb_tail = (fb_tail + 1) % FB_SIZE;
  if(fb_tail == fb_head)
	fb_head = (fb_head + 1) % FB_SIZE;
}
#endif

void init_elf(char *elf_file)
{
#ifdef CONFIG_FTRACE
  Log("\033[34mThe image is %s", elf_file);
  elf_fp = fopen(elf_file, "rb");
  if(!elf_fp)
  {
	printf("Elf file %s open fail, try again\n", elf_file);
	exit(1);
  }
  Elf32_Ehdr Ehdr;
  Assert(fread(&Ehdr, sizeof(Elf32_Ehdr), 1, elf_fp) == 1, "Read error at %s %d", __FILE__, __LINE__);


  Elf32_Shdr *Shdr = NULL;
  fseek(elf_fp, Ehdr.e_shoff, SEEK_SET);
  Shdr = (Elf32_Shdr *)malloc(Ehdr.e_shentsize * Ehdr.e_shnum);
  Assert(fread(Shdr, Ehdr.e_shentsize, Ehdr.e_shnum, elf_fp) == Ehdr.e_shnum, "Read error at %s %d", __FILE__, __LINE__);

  Elf32_Shdr strtab = Shdr[Ehdr.e_shstrndx - 1];
  char *str_array = (char *)malloc(strtab.sh_size);
  fseek(elf_fp, strtab.sh_offset, SEEK_SET);
  Assert(fread(str_array, strtab.sh_size, 1, elf_fp) == 1, "Read error at %s %d", __FILE__, __LINE__);

  int sym_length = 0;
  Elf32_Sym *sym = NULL;

  for(int i = 0; i < Ehdr.e_shnum; i++)
  {
	if(Shdr[i].sh_type == SHT_SYMTAB)
	{
	  sym_length = Shdr[i].sh_size / sizeof(Elf32_Sym);
	  sym = (Elf32_Sym *)malloc(Shdr[i].sh_size);
	  fseek(elf_fp, Shdr[i].sh_offset, SEEK_SET);
	  Assert(fread(sym, sizeof(Elf32_Sym), sym_length, elf_fp) == sym_length, "Read error at %s %d", __FILE__, __LINE__);
	  break;
	}
  }

  FUNC* fs = (FUNC*)malloc(sym_length * sizeof(FUNC));
  for(int i = 0; i < sym_length; i++)
  {
	if(ELF32_ST_TYPE(sym[i].st_info) == STT_FUNC)
	{
	  char *p = &str_array[sym[i].st_name];
	  int tmp_pos = 0;
	  fs[fun_top].addr = sym[i].st_value;
	  fs[fun_top].size = sym[i].st_size;
	  while(*p != 0)
		fs[fun_top].func_name[tmp_pos++] = *p++;
	  fs[fun_top].func_name[tmp_pos] = '\0';
	  fun_top++;
	}
  }

  functs = fs;
  for(int i = 0; i < fun_top; i++)
  {
	Log("Read function: name: %s, addr: %08x, size: %d", functs[i].func_name, functs[i].addr, functs[i].size);
  }
#endif
}

CPU_state cpu = {.csr ={[0x300] = 0x1800}};
uint64_t g_nr_guest_inst = 0;
static uint64_t g_timer = 0; // unit: us
static bool g_print_step = false;

void device_update();
#ifdef CONFIG_WATCHPOINT
uint32_t trace_wp();
#endif

static char iringbuf[IRING_SIZE][100] = {0};
static int iring_p = 0;

void display_iring()
{
  printf(YELLOW "Instruction Ring Tracer Log:\n" RESET);
  for(int i = 0;  i < IRING_SIZE; i++)
  {
	if(i == (iring_p - 1 + IRING_SIZE) % IRING_SIZE)
	{
	  printf(RED " -->");
	}
	printf("%s" RESET "\n", iringbuf[i]);
  }
}

static void trace_and_difftest(Decode *_this, vaddr_t dnpc) {
#ifdef CONFIG_ITRACE_COND
  if (ITRACE_COND) { log_write("%s\n", _this->logbuf); }
#endif
  if (g_print_step) { IFDEF(CONFIG_ITRACE, puts(_this->logbuf)); }
  IFDEF(CONFIG_DIFFTEST, difftest_step(_this->pc, dnpc));

#ifdef CONFIG_WATCHPOINT
  uint32_t tracer = trace_wp();
  if(tracer)
  {
	nemu_state.state = NEMU_STOP;
	printf("Watch point be trigered\n");
	return;
  }
#endif
}

#ifdef CONFIG_FTRACE
#define FUNCTION_MATCH do{\
	for(fun = 0; fun < fun_top; fun++)\
	{\
	  if(tar_addr >= functs[fun].addr && tar_addr < functs[fun].addr + functs[fun].size)\
		break;\
	}\
	if(fun == fun_top)\
	{\
	  printf("Unknown function at pc: %08x\n", s->pc);\
	  exit(1);\
	} \
}while(0)
#endif

#ifdef CONFIG_FTRACE
#define TRACE_FUNCTION do{\
  uint32_t full_inst = s->isa.inst;\
  uint8_t opcode = full_inst & 0x7f;\
  char fb_tmp[100] = {0};\
  uint8_t rd = (full_inst >> 7) & 0x1f;\
  uint8_t rs1 = (full_inst >> 15) & 0x1f;\
  int fun = 0;\
  if((opcode == 0b1101111 || opcode == 0b1100111) && rd == 1) /*call*/\
  {\
	uint32_t imm;\
	uint32_t tar_addr;\
	if(opcode == 0b1101111)\
	{\
	  imm = (((int32_t)full_inst >> 30) << 20) | (((full_inst >> 12) & 0xff) << 12) | (((full_inst >> 20) & 0x1) << 11) | (((full_inst >> 21) & 0x3ff) << 1);\
	  tar_addr = imm + pc;\
	}\
	else\
	{\
	  imm = (((int32_t)full_inst) >> 20);\
	  bool success;\
	  extern const char *regs[];\
	  tar_addr = imm + isa_reg_str2val(regs[rs1], &success);\
	  if(!success)\
	  {\
		printf("Unknown Reg\n");\
		exit(1);\
	  }\
	}\
	FUNCTION_MATCH;\
	int p = 0;\
	p += sprintf(fb_tmp, "0x%08x:-", s->pc);\
	for(int i = 0; i < layer; i++) p += sprintf(fb_tmp + p, "--");\
	p += sprintf(fb_tmp + p, "call [%s@%08x]", functs[fun].func_name, functs[fun].addr);\
	layer ++;\
	fb_inQue(fb_tmp);\
  }\
  else if(opcode == 0b1100111 && rs1 == 1 && rd == 0) /*ret*/\
  {\
	uint32_t imm = (((int32_t)full_inst) >> 20);\
	if(imm == 0)\
	{\
	  layer--;\
	  uint32_t tar_addr = s->pc;\
	  FUNCTION_MATCH;\
	  int p = 0;\
	  p += sprintf(fb_tmp, "0x%08x:-", s->pc);\
	  for(int i = 0; i < layer; i ++) p += sprintf(fb_tmp + p,  "--");\
	  p += sprintf(fb_tmp + p, "ret [%s]", functs[fun].func_name);\
	  fb_inQue(fb_tmp);\
	}\
  }\
} while(0);

void display_ft_buffer()
{
  printf(YELLOW "Function Tracer Log:\n" RESET);
  for(int i = fb_head; i != fb_tail; )
  {
	printf("%s\n", ftrace_buffer[i]);
	i = (i + 1) % FB_SIZE;
  }
}
#endif

static uint32_t nemu_current_pc = 0;
uint32_t get_current_pc()
{
  return nemu_current_pc;
}

static void exec_once(Decode *s, vaddr_t pc) {
  s->pc = pc;
  s->snpc = pc;
  isa_exec_once(s);
  nemu_current_pc = s->pc;
//  printf("%08x, %08x\n", s->pc, s->snpc);
  cpu.pc = s->dnpc;
  printf("%08x\n", s->isa.inst);
#ifdef CONFIG_ITRACE
  char *p = s->logbuf;
  p += snprintf(p, sizeof(s->logbuf), FMT_WORD ":", s->pc);
  int ilen = s->snpc - s->pc;
  int i;
  uint8_t *inst = (uint8_t *)&s->isa.inst;
#ifdef CONFIG_ISA_x86
//  printf("%08x, %08x, %d\n", s->pc, s->snpc, ilen);
  for (i = 0; i < ilen; i ++) {
#else
//  printf("%08x, %08x, %d\n", s->pc, s->snpc, ilen);
  for (i = ilen - 1; i >= 0; i --) {
#endif
    p += snprintf(p, 4, " %02x", inst[i]);
  }
  int ilen_max = MUXDEF(CONFIG_ISA_x86, 8, 4);
  int space_len = ilen_max - ilen;
  if (space_len < 0) space_len = 0;
  space_len = space_len * 3 + 1;
  memset(p, ' ', space_len);
  p += space_len;

  void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
  disassemble(p, s->logbuf + sizeof(s->logbuf) - p,
      MUXDEF(CONFIG_ISA_x86, s->snpc, s->pc), (uint8_t *)&s->isa.inst, ilen);
//  printf("inst: %x\n", *(uint8_t *)&s->isa.inst);
//  printf("%08x, %08x, %d\n", s->pc, s->snpc, ilen);
  char tmp[100] = {};
  sprintf(tmp, "\t0x%08x: %02x %02x %02x %02x %10s%s", s->pc, inst[3], inst[2], inst[1], inst[0], " ", p);
  memcpy(iringbuf[iring_p], tmp, 100);
  iring_p = (iring_p + 1) % IRING_SIZE;

#endif

#ifdef CONFIG_FTRACE
  TRACE_FUNCTION;
#endif
}


static void execute(uint64_t n) {
  Decode s;
  for (;n > 0; n --) {
    exec_once(&s, cpu.pc);
    g_nr_guest_inst ++;
    trace_and_difftest(&s, cpu.pc);
	/*
	if (nemu_state.state == NEMU_ABORT || (nemu_state.state != NEMU_RUNNING && nemu_state.halt_ret))
	  display_iring();
	  */
    if (nemu_state.state != NEMU_RUNNING) 
	{
#ifdef CONFIG_FTRACE
	  display_ft_buffer();
#endif
#ifdef CONFIG_MTRACE
	  extern void display_mt_buffer();
	  display_mt_buffer();
#endif
#ifdef CONFIG_ETRACE
	  void display_et();
	  display_et();
#endif
#ifdef CONFIG_ITRACE
	  display_iring();
#endif
	  break;
	}
    IFDEF(CONFIG_DEVICE, device_update());
  }
}

static void statistic() {
  IFNDEF(CONFIG_TARGET_AM, setlocale(LC_NUMERIC, ""));
#define NUMBERIC_FMT MUXDEF(CONFIG_TARGET_AM, "%", "%'") PRIu64
  Log("host time spent = " NUMBERIC_FMT " us", g_timer);
  Log("total guest instructions = " NUMBERIC_FMT, g_nr_guest_inst);
  if (g_timer > 0) Log("simulation frequency = " NUMBERIC_FMT " inst/s", g_nr_guest_inst * 1000000 / g_timer);
  else Log("Finish running in less than 1 us and can not calculate the simulation frequency");
}

void assert_fail_msg() {
  isa_reg_display();
  statistic();
}

/* Simulate how the CPU works. */
void cpu_exec(uint64_t n) {
  g_print_step = (n < MAX_INST_TO_PRINT);
//  printf("%d\n", nemu_state.state);
  switch (nemu_state.state) {
    case NEMU_END: case NEMU_ABORT: case NEMU_QUIT:
      printf("Program execution has ended. To restart the program, exit NEMU and run again.\n");
      return;
    default: nemu_state.state = NEMU_RUNNING;
  }

  uint64_t timer_start = get_time();

  execute(n);

  uint64_t timer_end = get_time();
  g_timer += timer_end - timer_start;

  switch (nemu_state.state) {
    case NEMU_RUNNING: nemu_state.state = NEMU_STOP; break;

    case NEMU_END: case NEMU_ABORT:
      Log("nemu: %s at pc = " FMT_WORD,
          (nemu_state.state == NEMU_ABORT ? ANSI_FMT("ABORT", ANSI_FG_RED) :
           (nemu_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN) :
            ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
          nemu_state.halt_pc);
      // fall through
    case NEMU_QUIT: statistic();
  }
}
