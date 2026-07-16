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
#include <memory/host.h>
#include <memory/vaddr.h>
#include <device/map.h>

#define IO_SPACE_MAX (32 * 1024 * 1024)

static uint8_t *io_space = NULL;
static uint8_t *p_space = NULL;

void display_device();

uint8_t* new_space(int size) {
  uint8_t *p = p_space;
  // page aligned;
  size = (size + (PAGE_SIZE - 1)) & ~PAGE_MASK;
  p_space += size;
  if(p_space - io_space > IO_SPACE_MAX)
	display_device();
  assert(p_space - io_space < IO_SPACE_MAX);
  return p;
}

static void check_bound(IOMap *map, paddr_t addr) {
  if (map == NULL) {
    Assert(map != NULL, "address (" FMT_PADDR ") is out of bound at pc = " FMT_WORD, addr, cpu.pc);
  } else {
	if(addr > map->high || addr < map->low)
	  display_device();
    Assert(addr <= map->high && addr >= map->low,
        "address (" FMT_PADDR ") is out of bound {%s} [" FMT_PADDR ", " FMT_PADDR "] at pc = " FMT_WORD,
        addr, map->name, map->low, map->high, cpu.pc);
  }
}

static void invoke_callback(io_callback_t c, paddr_t offset, int len, bool is_write) {
  if (c != NULL) { c(offset, len, is_write); }
}

void init_map() {
  io_space = malloc(IO_SPACE_MAX);
  assert(io_space);
  p_space = io_space;
}

char device_buffer[30][100];
int head = 0, tail = 0;
int buffer_size = 30;

void inQueue(char *str)
{
  sprintf(device_buffer[tail], "%s", str);
  tail = (tail + 1) % buffer_size;
  if(tail == head)
	head = (head + 1) % buffer_size;
}

void display_device()
{
  for(int i = head; i != tail; )
  {
	if((i + 1) % buffer_size == tail)
	  printf(" -->");
	printf("\t%s\n", device_buffer[i]);
	i = (i + 1) % buffer_size;
  }
}

word_t map_read(paddr_t addr, int len, IOMap *map) {
  if(len < 1 || len > 8)
	display_device();
  assert(len >= 1 && len <= 8);
  check_bound(map, addr);
  paddr_t offset = addr - map->low;
  invoke_callback(map->callback, offset, len, false); // prepare data to read
  word_t ret = host_read(map->space + offset, len);
  char tmp[100];
  sprintf(tmp, "0x%08x: Read  data: %5d form device: %s", cpu.pc,  ret, map->name);
  inQueue(tmp);
  return ret;
}

void map_write(paddr_t addr, int len, word_t data, IOMap *map) {
  if(len < 1 || len > 8)
	display_device();
  assert(len >= 1 && len <= 8);
  check_bound(map, addr);
  paddr_t offset = addr - map->low;
  host_write(map->space + offset, len, data);
  invoke_callback(map->callback, offset, len, true);
  char tmp[100];
  sprintf(tmp, "0x%08x; Write data: %5d  to  device: %s", cpu.pc, data, map->name);
  inQueue(tmp);
}
