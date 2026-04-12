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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <string.h>

#define Assert(cond, fmt, ...)\
  do{\
  if(!(cond))\
  {\
	fprintf(stderr, fmt, ##__VA_ARGS__);\
	abort();\
  }\
}while(0)

// this should be enough
static char buf[65536] = {};
static int cur_token = 0;
static char code_buf[65536 + 128] = {}; // a little larger than `buf`
static char *code_format =
"#include <stdio.h>\n"
"int main() { "
"  unsigned result = %s; "
"  printf(\"%%u\", result); "
"  return 0; "
"}";

static int buf_top = 0;

static int choose(int n)
{
  return rand() % n;
}


static void gen_num()
{
  uint32_t num;
  if(buf[buf_top - 1] == '/')
	while((num = rand() % 100) == 0);
  char *str_num = (char*)malloc(15 * sizeof(char));
  Assert(str_num, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
  sprintf(str_num, "%u", num);
  int length = strlen(str_num);
  for (int pos = 0; pos < length; pos ++)
  {
	buf[buf_top++] = str_num[pos];
  }
  cur_token += 1;
//  return str_num;
}

static void gen(char ch)
{
//  char *li = (char*)malloc(2 * sizeof(char));
 // Assert(li, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
//  li[0] = ch;
//  li[1] = '\0';
  buf[buf_top++] = ch;
  cur_token += 1;
//  return li;
}

static void gen_rand_op()
{
  char ops[] = "+-*/";
//  char *op = (char*)malloc(2 * sizeof(char));
//  Assert(op, "%s %s %d:Memory Allocation Error", __FILE__, __func__, __LINE__);
  int idx = choose(4);
//  op[0] = ops[idx];
  //op[1] = '\0';
  buf[buf_top ++] = ops[idx];
  cur_token += 1;
//  return op;
}

static void gen_blank()
{
  while(choose(2))
	if(choose(2))
	  buf[buf_top ++] = ' ';
  //return " ";
}

static void gen_rand_expr(int depth) {
//  buf[0] = '\0';
  int op = choose(3);
  /*
  if(cur_token >= 15)
  {
	gen_blank();
	gen_num();
	gen_blank();
	return;
  }
  if(op <= 5 && choose(2))
	op += 1;
	*/
  if(depth >= 10 || cur_token >= 15)
	op = 0;
  else if(depth <= 3 && choose(2))
	op += 1;
  switch (op) {
    case 0: gen_blank(); gen_num(); gen_blank(); break;
    case 1: gen_blank(); gen('('); gen_blank(); gen_rand_expr(depth + 1); gen_blank(); gen(')'); gen_blank(); break;
//	case 2: gen_blank(); break;
    default: gen_rand_expr(depth + 1); gen_blank(); gen_rand_op(); gen_blank(); gen_rand_expr(depth + 1); break;
  }
}

int main(int argc, char *argv[]) {
  srand((unsigned int)time(NULL));
  int seed = time(0);
  srand(seed);
  int loop = 1;
  if (argc > 1) {
    sscanf(argv[1], "%d", &loop);
  }
  int i;
  for (i = 0; i < loop; i ++) {
    gen_rand_expr(0);
	buf[buf_top] = '\0';

    sprintf(code_buf, code_format, buf);

    FILE *fp = fopen("/tmp/.code.c", "w");
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    int ret = system("gcc /tmp/.code.c -o /tmp/.expr");
    if (ret != 0) continue;

    fp = popen("/tmp/.expr", "r");
    assert(fp != NULL);

    int result;
    ret = fscanf(fp, "%d", &result);
    pclose(fp);

    printf("%u,%s\n", result, buf);
	fflush(stdout);
  }
  return 0;
}
