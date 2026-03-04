#include <stdio.h>
#include <stdlib.h>
#include <Vtop.h>
#include <verilated.h>

Vtop *top = new Vtop;

void one_cycle()
{
  top->clk = 0;
  top->eval();
  top->clk = 1;
  top->eval();
}
  
int main()
{
  
}  
