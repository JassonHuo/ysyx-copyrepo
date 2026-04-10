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

#include <isa.h>

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 256, TK_EQ, TK_NUM,

  /* TODO: Add more token types */

};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    // spaces
  {"\\+", '+'},         // plus
  {"==", TK_EQ},        // equal
  {"\\-", '-'},			// sub
  {"\\*", '*'},			// mux
  {"\\/", '/'},			// div
  {"\\(", '('},			// left parenthesis
  {"\\)", ')'},			// right parenthesis
  {"[0-9]+", TK_NUM},		// num
};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
//	printf("ret in expr: %d\n", ret);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

//static bool make_token(char *e) {
bool make_token(char *e){
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;

/*  for(i = 0; i < NR_REGEX; i ++)
  {
	char temp_char[2];
	temp_char[0] = rules[i].token_type;
	printf("%s: %d\n", (rules[i].token_type == TK_NOTYPE ? "TK_NOTYPE": 
		(rules[i].token_type == TK_NUM ? "TK_NUM": 
		temp_char)), rules[i].token_type);
  }
  */

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
            i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
		  case TK_NOTYPE: 
		  case '+':
		  case '-':
		  case '*':
		  case '/':
		  case '(':
		  case ')':
		  case TK_NUM:
//			char temp_str[2];
//			temp_str[0] = rules[i].token_type;		
			int substr_pos;
			tokens[nr_token].type = rules[i].token_type;
			for (substr_pos = 0; substr_pos < substr_len; substr_pos ++)
			{
			  tokens[nr_token].str[substr_pos] = *(substr_start + substr_pos);
//			  printf("%c, %c\n", tokens[nr_token].str[substr_pos], *(substr_start + substr_pos));
			}
			tokens[nr_token].str[substr_pos] = '\0';
			assert(tokens[nr_token].str == NULL);
/*			printf("type: %s, str: \"%s\"\n", rules[i].token_type == TK_NOTYPE ? "TK_NOTYPE":
				(rules[i].token_type == TK_NUM ? "TK_NUM":
				 temp_str), tokens[nr_token].str);
				 */
			nr_token += 1;
			break;
          default: 
			TODO();
        }

        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}


word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */
  TODO();

  return 0;
}
