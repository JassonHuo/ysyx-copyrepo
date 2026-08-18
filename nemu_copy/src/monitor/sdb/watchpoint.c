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

#include "sdb.h"

#define NR_WP 32

/*
typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  //TODO: Add more members if necessary
  //uint32_t point_addr;
  char *expr;
  struct watchpoint *prev;
  uint32_t expr_result;
} WP;
*/

#ifdef CONFIG_WATCHPOINT
static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;

enum {
  HW_WP = 255, SW_WP, READ_WP, ACC_WP, DISP_KEEP, DISP_DEL, DISP_DIS, ENB_Y, ENB_N, 
};
#endif

void init_wp_pool() {
#ifdef CONFIG_WATCHPOINT
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
	wp_pool[i].prev = (i == 0 ? NULL: &wp_pool[i - 1]);
	wp_pool[i].expr_result = 0;
	wp_pool[i].expr = "";
  }

  head = NULL;
  free_ = wp_pool;
#endif
}

/* TODO: Implement the functionality of watchpoint */
WP* new_wp(char *expr, word_t result)
{
#ifdef CONFIG_WATCHPOINT
  Assert(free_ != NULL,  "%s %s %d Memory Error: Watch Point Pool Overflow", __FILE__, __func__, __LINE__);
  WP *wp = free_;
  free_ = free_->next;
  if(free_ != NULL) free_->prev = NULL;
  wp->next = NULL;
  wp->prev = NULL;
//  wp->point_addr = addr;
  char *expr_str = (char*)malloc((1 + strlen(expr)) * sizeof(char));
  strcpy(expr_str, expr);
  wp->expr = expr_str;
  wp->expr_result = result;
//  printf("%s\n", wp->expr);
  if(!head)
	head = wp;
  else
  {
	head->prev = wp;
	wp->next = head;
	head = wp;
  }
//  printf("%s\n", wp->expr);
/*
  for(int i = 0; i < 32; i ++)
  {
	printf("%d %s\n", i, wp_pool[i].expr);
  }
  */
  return wp;
#else
  return NULL;
#endif
}

void free_wp(WP* wp)
{
#ifdef CONFIG_WATCHPOINT
  Assert(wp != NULL, "%s %s %d: wp is NULL", __FILE__, __func__, __LINE__);
  Assert(head != NULL, "%s %s %d Memory Error: Watch Point Pool Overflow", __FILE__, __func__, __LINE__);
  if(wp == head)
  {
	head = head->next;
	if(head) head->prev = NULL;
	wp->next = NULL;
	wp->prev = NULL;
	if(free_ == NULL)
	  free_ = wp;
	else
	{
	  free_->prev = wp;
	  wp->next = free_;
	  free_ = wp;
	}
  }
  else
  {
	if(wp->prev != NULL) wp->prev->next = wp->next;
	if(wp->next != NULL) wp->next->prev = wp->prev;
	wp->next = NULL;
	wp->prev = NULL;
	if(free_ == NULL)
	  free_ = wp;
	else
	{
	  free_->prev = wp;
	  wp->next = free_;
	  free_ = wp;
	}
  }
#endif
}

void delete_wp(int num)
{
#ifdef CONFIG_WATCHPOINT
  WP *p = head;
  while(p)
  {
	if(p->NO == num)
	{
	  free_wp(p);
	  return;
	}
	else
	  p = p->next;
  }
  printf("Don't have watch point NO%d\n", num);
#endif
}

void display_wp()
{
#ifdef CONFIG_WATCHPOINT
  /*
  for(int i = 0; i < 32; i ++)
  {
	printf("%d %s\n", i, wp_pool[i].expr);
  }
  */
  WP *p = head;
//  printf("%s\n", p->expr);
//  printf("%s\n", head->expr);
  if(head == NULL)
  {
	printf("No watch point have be set\n");
	return;
  }
  printf("Num\tType\t\tDisp\tEnb\tAddress\tWhat\n");
//  printf("%s\n", p->expr);
  while(p)
  {
	int num = p->NO;
//	char *type, *disp, *enb, *address, *what;
	printf("%d\t%s\t%s\t%s\t%s\t%s\n", num, "watchpoint", "keep", "y", "", p->expr);
	p = p->next;
  }
#endif
}

uint32_t trace_wp()
{
#ifdef CONFIG_WATCHPOINT
  WP *p = head;
  uint32_t flag = 0;
  bool success;
  while(p)
  {
	uint32_t result = expr(p->expr, &success);
	if(result != p->expr_result)
	{
	  flag = 1;
	  p->expr_result= result; 
	}
	p = p->next;
  }
  return flag;
#else
  return 0;
#endif
}
