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

#include <common.h>

void init_monitor(int, char *[]);
void am_init_monitor();
void engine_start();
int is_exit_status_bad();
word_t expr();

extern bool div_by_zero;
//bool make_token();
uint32_t range_start;

uint32_t range_end;

int main(int argc, char *argv[]) {
  /* Initialize the monitor. */
#ifdef CONFIG_TARGET_AM
  printf("here\n");
  am_init_monitor();
#else
  init_monitor(argc, argv);
#endif

#ifdef CONFIG_EN_MTRACE_RANGE
sscanf(CONFIG_RANGE_START, "%x", &range_start);
sscanf(CONFIG_RANGE_END, "%x", &range_end);
#endif

#ifdef CHECK_EVAL
//  make_token("45 +       36*(241235- 11435         )              ");
  bool success;
  for (int i = 0; i < 10000; i ++)
  {
	FILE *fp;
	fp = popen("/home/jasonhuo/ysyx/ysyx-workbench/nemu/tools/gen-expr/build/gen-expr 2>/dev/null", "r");
	Assert(fp, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
	char line[4096];
	Assert(fgets(line, sizeof(line), fp), "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
	line[strcspn(line, "\n")] = '\0';
	char *comma = strchr(line, ',');
	Assert(comma, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
	*comma = '\0';
	char *result = line;
	char *expression = comma + 1;
	unsigned int real_result = expr(expression, &success);
	if(div_by_zero == true)
	{
	  printf("div_by_zero: %d\n", div_by_zero);
	  i --;
	  pclose(fp);
	  continue;
	}
	if(!success || atoi(result) != real_result)
	{
	  printf("Result Error\n");
	  printf("success: %d,\nexpression:%s\nresult = %u,\nperfect_result = %u\n", success, expression, real_result, atoi(result));
	  return 1;
	}
	pclose(fp);
	fp = NULL;
	printf("%d/10000\n", i);
  }
  printf("Pass\n");
#endif
  /* Start engine. */
  engine_start();

  return is_exit_status_bad();
}

