#include <stdio.h>
#include <Vtop.h>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdint.h>
#include "svdpi.h"
#include "Vtop__Dpi.h"
#include <limits.h>
#include <fstream>
#include <cstring>
#include <iostream>	
#include <sstream>
#include <time.h>
#include <sys/time.h>
#include "sdb.h"

#define EBREAK 0x00100073 
#define MEM_SIZE 134217727
#define GREEN "\033[32m"
#define RED "\033[31m"
#define BLUE "\033[34m"
#define RESET "\033[0m"

//#define ARR_SIZE(arr) (int)(sizeof(arr) / sizeof(arr[0]))

bool ebreak_happened = false;
bool npcsdb_quit = false;
uint32_t mem[MEM_SIZE] = {0};
static VerilatedContext *contextp = new VerilatedContext;
static VerilatedVcdC* tracep = new VerilatedVcdC;
static Vtop *top = new Vtop;

static struct timeval tv;
static uint8_t *serial_base = NULL;
static uint64_t start_time;

static void init_file(char *args);
static void init_batch_mode(char *args);

FILE *fp = NULL;

static struct {
  const char *signal;
  int arg_num;
  void (*init)(char *);
} arg_table[] = {
  {"-f", 1, init_file},
  {"-b", 0, init_batch_mode},
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
  extern int batch_mode_open();
  batch_mode_open();
}


void ebreak()
{
  ebreak_happened = true;
  printf("[%s:%d %s] npc: ", __FILE__, __LINE__, __func__);
  if(!top->a0)
	printf(GREEN "HIT GOOD TRAP " RESET);
  else
	printf(RED "HIT BAD TRAP " RESET);
  printf("at pc = %08x\n", top->pc);
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

extern "C" int pmem_read(int addr)
{
  if(addr == 0x10000000) return 0;
  else if(addr == 0x10000048) return (uint32_t)get_time();
  else if(addr == 0x1000004c) return get_time() >> 32;
  return mem[((uint32_t)addr - 0x80000000) >> 2];
}

extern "C" void pmem_write(int waddr, int wdata, char wmask)
{
  if(top->clk)
  {
	if(waddr == 0x10000048) return;
	else if(waddr == 0x1000004c) return;
	else if(waddr == 0x10000000)
	{
      putchar(wdata);
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
  }
}


uint32_t hex2num(std::string &hex)
{
  return std::stoul(hex, nullptr, 16);
}


int c_get_Reg(int idx)
{
  extern int get_Reg(int idx);
  svSetScope(svGetScopeFromName("TOP.top.gpr0.Gpr"));
  return (uint32_t)get_Reg(idx);
}

void run_cycle(uint64_t n)
{
  for(uint64_t i = 0; i < n && !ebreak_happened; i ++)
  {
	top->clk = 0;
	top->eval();
	if(ebreak_happened)break;
	top->clk = 1;
	top->eval();
  }
}
int main(int argc, char** argv) {
  printf(BLUE "Open physical memory area [0x80000000, 0x87ffffff]" RESET "\n");
  printf(BLUE "Open device serial at [0x10000000, 0x10000004]" RESET "\n");
  printf(BLUE "Open device rtc at [0x10000048, 0x1000004f]" RESET "\n");

  read_arg(argc, argv);

  top->rst = 1;
  for(int i = 0; i < 10; i ++)
  {
	top->clk = 0;
	top->eval();
	top->clk = 1;
	top->eval();
  }
  top->rst = 0;

  top->rst = 0;
  time_init();
  while(!contextp->gotFinish() && !ebreak_happened && !npcsdb_quit)
  {
//	run_cycle(1);
	sdb_mainloop();
  }
  delete top;
  return top->a0;
}
