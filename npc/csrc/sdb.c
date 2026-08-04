#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <stdlib.h>
#include "sdb.h"
#include <stdint.h>

static int cmd_help(char *args);
static int cmd_si(char *args);
static int cmd_info(char *args);
static int cmd_x(char *args);
static int cmd_q(char *args);
static int cmd_c(char *args);

static bool batch_mode = false;
extern int NPC_state;
extern uint32_t c_get_Pc();

const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2", 
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", 
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", 
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

const char *get_reg_name(int i)
{
  return regs[i];
}

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table[] = {
  {"help", "Display information about all support commands", cmd_help},
  {"c" , "Continue to run", cmd_c},
  {"si", "Execute by step", cmd_si},
  {"info", "Display the status of gpr", cmd_info},
  {"x", "Scanf the memory", cmd_x},
  {"q", "quit the sdb", cmd_q},
};

int CMD_SIZE = ARR_SIZE(cmd_table);

void run_cycle(uint64_t n);
int c_get_Reg(int idx);

static char* rl_gets()
{
  static char *line = NULL;
  if(line)
  {
	free(line);
	line = NULL;
  }

  line = readline("(npc) ");
  if(line && *line)
	add_history(line);
  return line;
}

void batch_mode_open()
{
  batch_mode = true;
}

int cmd_help(char *args)
{
  for(int i = 0; i < CMD_SIZE; i ++)
  {
	printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
  }
  return 0;
}

int cmd_c(char *args)
{
  if(NPC_state == NPC_END)
  {
	printf("Program execution has ended. To restart the program, exit NPC and run again.\n");
	return 0;
  }
  NPC_state = NPC_RUNNING;
  run_cycle(-1);
  return 0;
}

int cmd_si(char *args)
{
  if(NPC_state == NPC_END)
  {
	printf("Program execution has ended. To restart the program, exit NPC and run again.\n");
	return 0;
  }
  char *arg = strtok(args, " ");
  int n = 1;
  NPC_state = NPC_RUNNING;
  if(arg)
	n = atoi(arg);
  run_cycle(n);
  NPC_state = NPC_STOP;
  return 0;
}

void display_regs()
{
  printf("Index     Name    Hex          Dec\n");
  printf("---------------------------------------\n");
  for(int i = 0; i < Reg_Num; i ++)
  {
	uint32_t reg_value = c_get_Reg(i);
	printf("gpr[%d]\t%5s:  %08x | %012d\n", i, regs[i], reg_value, reg_value);
  }
}

void display_mem(int n, uint32_t addr)
{
  extern uint32_t mem[];
  for(int i = 0; i < n; i ++)
  {
	uint32_t p = addr + i;
	if(p > 0x87ffffff || p < 0x80000000)
	{
	  printf("addr %08x out of range\n", p);
	  return;
	}
	printf("0x%08x: %08x\n", p, mem[(p - 0x80000000) >> 2]);
  }
}

int cmd_info(char *args)
{
  if(args == NULL) return 0;
  char *arg = strtok(args, " ");
  if(!strcmp(arg, "r"))
	display_regs();
  return 0;
}

int cmd_x(char *args)
{
  char *arg_end = args + strlen(args);
  char *arg1 = strtok(args, " ");
  char *arg2 = arg1 + strlen(arg1) + 1;
  int n = 1;
  if(arg2 >= arg_end)
	arg2 = NULL;
  char *argaddr = NULL;
  if(arg2 == NULL)
  {
	argaddr = arg1;
  }
  else
  {
	n = atoi(arg1);
	argaddr = arg2;
  }
  uint32_t addr;
  sscanf(argaddr, "%x", &addr);
  display_mem(n, addr);
  return 0;
}

int cmd_q(char *args)
{
  NPC_state = NPC_QUIT;
  return 0;
}

void sdb_mainloop()
{
  while(NPC_state != NPC_QUIT)
  {
  if(batch_mode)
  {
	cmd_c(NULL);
	if(NPC_state == NPC_ABORT)
	  break;
	return;
  }

  char *str = rl_gets();
  char *str_end = str + strlen(str);
  char *cmd = strtok(str, " ");
  if(cmd == NULL)
	continue;
  char *args = cmd + strlen(cmd) + 1;
  if(args >= str_end)
	args = NULL;

  for(int i = 0; i < CMD_SIZE; i ++)
  {
	if(!strcmp(cmd_table[i].name, cmd))
	{
	  cmd_table[i].handler(args);
	  break;
	}
	if(i == CMD_SIZE - 1)
	{
	  printf("Unknown command %s\n", cmd);
	}
  }
  }

}
