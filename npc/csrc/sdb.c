#include <sdb.h>

static int cmd_help(char *args);
static int cmd_si(char *args);
static int cmd_info(char *args);
static int cmd_x(char *args);

int table_size = 4;
static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table[] = {
  {"help", "Display information about all support commands", cmd_help},
  {"si", "Execute by step", cmd_si},
  {"info", "Display the status of gpr", cmd_info},
  {"x", "Scanf the memory", cmd_x},
};

