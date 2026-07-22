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

extern void run_cycle(uint64_t n);
extern int c_get_Reg(uint32_t idx);

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
  run_cycle(-1);
  return 0;
}

int cmd_si(char *args)
{
  char *arg = strtok(args, " ");
  int n = 1;
  if(arg)
	n = atoi(arg);
  run_cycle(n);
  return 0;
}

int cmd_info(char *args)
{
  return 0;
}

int cmd_x(char *args)
{
  return 0;
}

int cmd_q(char *args)
{
  extern bool npcsdb_quit;
  npcsdb_quit = true;
  return 0;
}

void sdb_mainloop()
{
  if(batch_mode)
  {
	cmd_c(NULL);
	return;
  }

  char *str = rl_gets();
  char *str_end = str + strlen(str);
  char *cmd = strtok(str, " ");
  if(cmd == NULL)
	return;
  char *args = cmd + strlen(cmd) + 1;
  if(args >= str_end)
	args = NULL;

  for(int i = 0; i < CMD_SIZE; i ++)
  {
	if(!strcmp(cmd_table[i].name, cmd))
	{
	  cmd_table[i].handler(args);
	  return;
	}
	if(i == CMD_SIZE - 1)
	{
	  printf("Unknown command %s\n", cmd);
	}
  }
}
