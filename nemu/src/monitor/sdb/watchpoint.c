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

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  /* TODO: Add more members if necessary */
  uint32_t point_addr;
  struct watchpoint *prev;
} WP;

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL, *tail = NULL;

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
	wp_pool[i].prev = (i == 0 ? NULL: &wp_pool[i - 1]);
  }

  head = NULL;
  tail = head;
  free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */
WP* new_wp(uint32_t addr)
{
  Assert(free_ != NULL,  "%s %s %d Memory Error: Watch Point Pool Overflow", __FILE__, __func__, __LINE__);
  WP * tmp = free_;
  free_ = free_->next;
  tail->next = tmp;
  tmp->prev = tail;
  tmp->next = NULL;
  tail = tmp;
  tmp->point_addr = addr;
  return tail;
}

void free_wp(WP* wp, bool* success)
{
  Assert(head != NULL, "%s %s %d Memory Error: Watch Point Pool Overflow", __FILE__, __func__, __LINE__);
}
