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

static bool make_token(char *e) {
//bool make_token(char *e){
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

  while (e[position] != '\0' && e[position] != '\n') {
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
			break;
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
			assert(tokens[nr_token].str != NULL);
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

bool check_parentheses(int p, int q)
{
  /*
  int stack_size = 32;
//  Token token_stack[32] = {};
  Token *token_stack = (Token*)malloc(stack_size * sizeof(Token));
  Assert(token_stack, "%s %d in function:%s\nMemory allocation failed", __FILE__, __LINE__, __func__);
  int stack_top = 0;
  for (int i = p; i <= q; i ++)
  {
	if (tokens[i].type == '(')
	{
	  token_stack[stack_top] = tokens[i];
	  stack_top += 1;
	  if(stack_top >= stack_size && i != q)
	  {
		Token* new_stack = (Token*)malloc((stack_size + 5)* sizeof(Token));
		assert(new_stack != NULL);
		for(int j = 0; j < stack_top; j ++)
		{
		  new_stack[j] = token_stack[j]; 
		}
		free(token_stack);
		token_stack = new_stack;
		stack_size += 5;
	  }
	}else if(tokens[i].type == ')')
	{
	  if (stack_top == 0)
	  {
		free(token_stack);
		return false;
	  }
	  stack_top -= 1;
	}
  }
  free(token_stack);
  return stack_top == 0 && tokens[p].type == '(' && tokens[q].type == ')';
  */
  int pos;
  if (tokens[p].type != '(' || tokens[q].type != ')')
	return false;
  int stack_size = 32;
  Token *token_stack = (Token*)malloc(stack_size * sizeof(Token));
  Assert(token_stack, "%s %d in function:%s\nMemory allocation failed", __FILE__, __LINE__, __func__);
  int stack_top = 0;
  for(pos = p + 1; pos < q; pos ++)
  {
	if(tokens[pos].type == '(')
	{
	  token_stack[stack_top] = tokens[pos];
	  stack_top += 1;
	}
	else if(tokens[pos].type == ')')
	{
	  if(stack_top == 0)
	  {
		free(token_stack);
		return false;
	  }
	  stack_top -= 1;
	}
  }
  free(token_stack);
  return stack_top == 0;
}

bool valid_result = true;

static uint32_t eval(int p, int q) {
  //printf("%d, %d\n", p, q);
  if (p > q) {
//	printf("Error in %s %d, function: %s\n", __FILE__, __LINE__, __func__);
//	exit(1);
	printf("Expression Error\n");
	valid_result = false;
	return 0;
  }
  else if (p == q) {
    /* Single token.
     * For now this token should be a number.
     * Return the value of the number.
     */
	if(tokens[p].type == TK_NUM)
	  return atoi(tokens[p].str);
	//printf("Error in %s %d, function: %s\n", __FILE__, __LINE__, __func__);
	//exit(1);
	  printf("Expression Error\n");
	  valid_result = false;	
	  return 0;
  }
  else if (check_parentheses(p, q) == true) {
    /* The expression is surrounded by a matched pair of parentheses.
     * If that is the case, just throw away the parentheses.
     */
    return eval(p + 1, q - 1);
  }
  else {
	int op = -1;
	int last_op = -1;
	int in_parentheses = 0;
	for(int pos = q; pos >= p; pos --)
	{
	  if(!in_parentheses && 
		  (tokens[pos].type == '+' || 
		   tokens[pos].type == '-'))
	  {
		op = pos;
		break;
	  }
	  else if(!in_parentheses && (tokens[pos].type == '*' ||
		  tokens[pos].type == '/') &&
		  last_op < 0)
		last_op = pos;
	  else if(tokens[pos].type == ')')
		in_parentheses += 1;
	  else if(tokens[pos].type == '(')
		in_parentheses -= 1;
	}
	if (op < 0)
	{
	  if(last_op < 0)
	  {
		printf("Expression error\n");
		valid_result = false;
		return 0;
	  }

	  op = last_op;	
	}
    uint32_t val1 = eval(p, op - 1);
    uint32_t val2 = eval(op + 1, q);

    switch (tokens[op].type) {
      case '+': return val1 + val2;
      case '-': return val1 - val2;
      case '*': return val1 * val2; 
      case '/':	return val1 / val2; 
      default: assert(0);
    }
  }
}

/*
uint32_t do_compression()
{
  return eval(0, nr_token);
}
*/

word_t expr(char *e, bool *success) {
  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  /* TODO: Insert codes to evaluate the expression. */
//  TODO();
  uint32_t expr_result = eval(0, nr_token - 1);
  *success = true;
  if(valid_result)
	printf("%u\n", expr_result);
  valid_result = true;
//  return 0;
  return expr_result;
}
