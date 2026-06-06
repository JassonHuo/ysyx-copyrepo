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

int main(int argc, char *argv[]) {
  /* Initialize the monitor. */
#ifdef CONFIG_TARGET_AM
  am_init_monitor();
#else
  init_monitor(argc, argv);
#endif

#ifdef CHECK_EVAL
//  make_token("45 +       36*(241235- 11435         )              ");
  bool success;
  for (int i = 0; i < 10000; i ++)
  {
	FILE *fp;
//	FILE *out = stdout;
	fp = popen("/home/jasonhuo/ysyx/ysyx-workbench/nemu/tools/gen-expr/build/gen-expr 2>/dev/null", "r");
//	char buffer[70000];
	Assert(fp, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
	//Assert(fgets(buffer, 60000, fp) != NULL, "%s %s %d: Error", __FILE__, __func__, __LINE__);
//	printf("%s\n", buffer);
//	uint32_t result = (uint32_t)atoi(strtok(buffer, " "));
//	char result[10];
//	char expression[700];
//	Assert(fscanf(fp, "%s,%s", result, expression) == 2, "%s %s %d: Memory Allocation Error", __FILE__, __func__, __LINE__);
	char line[4096];
	Assert(fgets(line, sizeof(line), fp), "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
	line[strcspn(line, "\n")] = '\0';
	char *comma = strchr(line, ',');
	Assert(comma, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
	*comma = '\0';
	char *result = line;
	char *expression = comma + 1;
//	printf("expression: %s \n", expression);
//	printf("perfect result %u\n", atoi(result));
	unsigned int real_result = expr(expression, &success);
	if(div_by_zero == true)
	{
	  printf("div_by_zero: %d\n", div_by_zero);
//	  div_by_zero = false;
	  i --;
	  pclose(fp);
	  continue;
	}
//	char buffer_real[70000];
//	Assert(fgets(buffer_real, 70000, out) != NULL, "%s %s %d: Error", __FILE__, __func__, __LINE__);
//	uint32_t real_result = atoi(buffer_real);
//	printf("result: %u\n", real_result);
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

