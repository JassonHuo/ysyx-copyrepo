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
//#include <device/map.h>
//#include <am.h>

#define EBREAK 0x00100073 
#define MEM_SIZE 134217727
#define GREEN "\033[32m"
#define RED "\033[31m"
#define BLUE "\033[34m"
#define RESET "\033[0m"

bool ebreak_happened = false;
uint32_t mem[MEM_SIZE] = {0};
static VerilatedContext *contextp = new VerilatedContext;
static VerilatedVcdC* tracep = new VerilatedVcdC;
static Vtop *top = new Vtop;

static struct timeval tv;
static uint8_t *serial_base = NULL;
static uint64_t start_time;


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
//  printf("data: %08x\n", mem[(addr - 0x80000000) >> 2]);
  /*
  if((uint32_t)addr >= 0x80000000 + MEM_SIZE + 3 || (uint32_t)addr < 0x80000000)
  {
	printf("Address %08x out of range %08x-%08x, at pc: %08x\n", addr, MEM_SIZE, 0x80000000 + MEM_SIZE, top->pc);
	ebreak();
  }
  */
//  printf("c read %x, index: %d, pc: %08x\n", mem[((uint32_t)addr - 0x80000000) >> 2], (addr - 0x80000000) >> 2, top->pc);
//  if(addr == 0xa0000048) return get_time();
  if(addr == 0x10000000) return 0;
  else if(addr == 0x10000048) return (uint32_t)get_time();
  else if(addr == 0x1000004c) return get_time() >> 32;
  return mem[((uint32_t)addr - 0x80000000) >> 2];
//  return mem[addr >> 2];
}

extern "C" void pmem_write(int waddr, int wdata, char wmask)
{
//  std::cout << "test";
  /*
  if((uint32_t)waddr >= 0x80000000 + MEM_SIZE + 3 || (uint32_t)waddr < 0x80000000)
  {
	printf("Address %08x out of range %08x-%08x, at pc: %08x\n", waddr, MEM_SIZE, 0x80000000 + MEM_SIZE, top->pc);
	ebreak();
  }
  */
  /*
  printf("%08x\n", waddr);
  if(waddr == 0x10000000) 
  {
//	putchar(wdata);
	printf("%c\n", wdata);
	return;
  }
  */
  if(top->clk)
  {
	/*
	if(waddr > 0x87ffffff || waddr < 0x80000000)
	  printf("%08x\n", waddr);
	  */
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
//  uint32_t tmp = mem[waddr >> 2];
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
	//  printf("%x, %x\n", mask, wdata);
	  tmp = (tmp & ~mask) | (wdata & mask);
	//  printf("%8x\n", tmp);
	//  printf("c write %x, index: %d, pc: %08x\n", tmp, (waddr - 0x80000000) >> 2, top->pc); 
	  mem[((uint32_t)waddr - 0x80000000) >> 2] = tmp;
	  }
  }
}


uint32_t hex2num(std::string &hex)
{
  return std::stoul(hex, nullptr, 16);
}

/*
void init_serial()
{
  serial_base = new_space(8);
#ifdef CONFIG_HAS_PORT_IO
  add_pio_map("serial", 0x10000000, serial_base, 8, NULL);
#else
  add_mmio_map("serial", 0x10000000, serial_base, 8, NULL);
#endif
}
*/

int c_get_Reg(int idx)
{
  extern int get_Reg(int idx);
  svSetScope(svGetScopeFromName("TOP.top.gpr0.Gpr"));
  return get_Reg(idx);
}

void run_cycle(int n)
{
  for(int i = 0; i < n && !ebreak_happened; i ++)
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

  if(argc == 1)
  {
	mem[0] = 0x00c00093;
	mem[1] = 0x0480a103;
	mem[2] = 0x0ef00193;
	mem[3] = 0x0cd00213;
	mem[4] = 0x0ab00293;
	mem[5] = 0x09000313;
	mem[6] = 0x04308423;
	mem[7] = 0x044084a3;
	mem[8] = 0x04508523;
	mem[9] = 0x046085a3;
	mem[10] = 0x0480a383;
	mem[11] = EBREAK;
	mem[21] = 0x12345678;
  }
  else if(argc > 2)
  {
	printf("To many file\n");
	exit(1);
  }
  else if(argc == 2)
  {
	std::string file_name = argv[1];
	std::string type = file_name.substr(file_name.find('.') + 1);
	if(type == "hex")
	{
	std::ifstream file;
	file.open(file_name);
	if(!file.is_open())
	{
	  printf("Open file error\n");
	  exit(1);
   	}

	int mem_top = 0;
	std::string line;
	while(std::getline(file, line))
	{
	  if(line.empty() || line[0] == '#' || line.substr(0, 2) == "//") continue;
	  std::istringstream iss(line);
	  std::string token;
	  size_t colon_pos = line.find(':');
	  if(colon_pos != std::string::npos)
	  {
		line = line.substr(colon_pos + 1);
	  }
	  while(iss >> token)
	  {
		if(token.size() != 8)
		  continue;
		mem[mem_top++]  = hex2num(token);
		if(mem_top >= MEM_SIZE)
		{
		  printf("To many codes\n");
		  exit(1);
		}
	  }
	}
	file.close();
	}
  else if(type == "bin")
  {
	std::ifstream file (file_name, std::ios::binary);
	if(!file.is_open()){
	  printf("file open error\n");
	  exit(1);
	}
	int mem_top = 0;
	while(file.read(reinterpret_cast<char*>(&mem[mem_top++]), 4))
	{
	  if(mem_top >= MEM_SIZE)
	  {
		printf("To many codes\n");
		exit(1);
	  }
	}
  }
  } 

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
  while(!contextp->gotFinish() && !ebreak_happened)
  {
	run_cycle(1);
  }
  delete top;
  return top->a0;
}
