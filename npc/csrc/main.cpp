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

#define EBREAK 0x00100073 
#define MEM_SIZE 1048576

bool ebreak_happened = false;
uint32_t mem[MEM_SIZE] = {0};

void ebreak()
{
  ebreak_happened = true;
}

extern "C" int pmem_read(int addr)
{
//  printf("%08x\n", addr);
  return mem[(addr - 0x80000000) >> 2];
//  return mem[addr >> 2];
}

extern "C" void pmem_write(int waddr, int wdata, char wmask)
{
//  std::cout << "test";
  uint32_t tmp = mem[(waddr - 0x80000000) >> 2];
//  uint32_t tmp = mem[waddr >> 2];
  uint32_t byte_mask = 0;
  /*
  for(int byte = 0; byte < 4; byte ++)
  {
	byte_mask = wmask % 2;
	wmask /= 2;
	if(byte_mask)
	{
	  tmp = (tmp & ~(0xFF << byte * 8)) | (wdata & (0xFF << byte * 8));
	}
  }
  */
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
  mem[(waddr - 0x80000000) >> 2] = tmp;
}

uint32_t hex2num(std::string &hex)
{
  return std::stoul(hex, nullptr, 16);
}

int main(int argc, char** argv) {
//  uint32_t mem[1024] = {0};
//  mem[0] = 0x00400093;
 // mem[1] = 0x0100a103;
  //mem[2] = 0x00100073;
  //mem[5] = 0x90abcdef;

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
//	  printf("%d\n", mem_top);
	  if(mem_top >= MEM_SIZE)
	  {
		printf("To many codes\n");
		exit(1);
	  }
	}
  }
  } 
  VerilatedContext *contextp = new VerilatedContext;
  VerilatedVcdC* tracep = new VerilatedVcdC;
  Vtop *top = new Vtop;

  top->rst = 1;
  for(int i = 0; i < 10; i ++)
  {
	top->clk = 0;
	top->eval();
	top->clk = 1;
	top->eval();
  }
  top->rst = 0;

  contextp->traceEverOn(true);
  top->trace(tracep, 99);
  tracep->open("wave.vcd");
  top->rst = 0;
  uint64_t cycle_num = 0;
  while(!contextp->gotFinish() && !ebreak_happened)
  {
	top->clk = 0;
	top->inst = pmem_read(top->pc);
//	printf("%x\n", top->inst);
	top->eval();
	tracep->dump(contextp->time());
	contextp->timeInc(1);
	top->clk = 1;
	top->eval();
	tracep->dump(contextp->time());
	contextp->timeInc(1);
	/*
	if(mem[top->inst_addr >> 2] == 0)
	{
	  top->clk = 0;
	  top->eval();
	  tracep->dump(contextp->time());
	  contextp->timeInc(1);
	  break;
	}
	*/
	cycle_num ++;
  }
  tracep->close();
  delete top;
//  std::cout << cycle_num <<std::endl;
  return 0;
}
