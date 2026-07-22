#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
static int cmd_help(char *args);
static int cmd_si(char *args);
static int cmd_info(char *args);
static int cmd_x(char *args);
static int cmd_q(char *args);

static bool batch_mode = false;

int table_size = 5;
static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table[] = {
  {"help", "Display information about all support commands", cmd_help},
  {"si", "Execute by step", cmd_si},
  {"info", "Display the status of gpr", cmd_info},
  {"x", "Scanf the memory", cmd_x},
  {"q", "quit the sdb", cmd_q},
};

extern void run_cycle(int n);
extern int c_get_Reg(int idx);

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
  for(int i = 0; i < table_size; i ++)
  {
	printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
  }
  return 0;
}

int cmd_si(char *args)
{
  int n = 1;
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
  return 0;
}
