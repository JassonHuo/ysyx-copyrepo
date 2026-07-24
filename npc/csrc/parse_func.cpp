#include <stdio.h>
#include <elf.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <errno.h>

FILE *elf_fp = NULL;
typedef struct{
  char name[20];
  uint32_t addr;
  int size;
}FUNC;
FUNC FUNC_table[100];

int func_top = 0;

Elf32_Sym *sym = NULL;
char *strarr = NULL;

char *march_func(uint32_t addr)
{
  char *func_name = (char *)malloc(20 * sizeof(char));
  for(int i = 0; i < func_top; i ++)
  {
	if(addr >= FUNC_table[i].addr && addr < FUNC_table[i].addr + FUNC_table[i].size)
	{
	  strcpy(func_name, FUNC_table[i].name);
	  return func_name;
	}
  }
  printf("Unknown function at %08x\n", addr);
  return NULL;
}

void init_elf(char *file_name)
{
  file_name = strtok(file_name, ",");
  if(file_name == NULL)
  {
	printf("No elf file\n");
	exit(1);
  }
  elf_fp = fopen(file_name, "rb");
  if(elf_fp == NULL)
  {
	printf("Elf file %s open fail,try again\n", file_name);
	perror("fopen failed");
	printf("Error code:%d\n", errno);
	exit(1);
  }
  Elf32_Ehdr Ehdr;
  int ret = fread(&Ehdr, sizeof(Elf32_Ehdr), 1, elf_fp);
  assert(ret >= 1);
  int str_idx = Ehdr.e_shstrndx - 1;
  fseek(elf_fp, Ehdr.e_shoff, SEEK_SET);
  
  Elf32_Shdr *Shdr = (Elf32_Shdr*)malloc(Ehdr.e_shnum * Ehdr.e_shentsize);
  ret =  fread(Shdr, Ehdr.e_shentsize, Ehdr.e_shnum, elf_fp);
  assert(ret >= Ehdr.e_shnum);
  Elf32_Shdr str_hdr = Shdr[str_idx];

  strarr = (char *)malloc(sizeof(char) * str_hdr.sh_size);
  fseek(elf_fp, str_hdr.sh_offset, SEEK_SET);
  ret =  fread(strarr, str_hdr.sh_size, 1, elf_fp);
  assert(ret >= 1);

  int offset = 0;
  for(offset = 0; offset < Ehdr.e_shnum; offset ++)
  {
	if(Shdr[offset].sh_type == SHT_SYMTAB)
	{
	  sym = (Elf32_Sym*)malloc(Shdr[offset].sh_size * sizeof(Elf32_Sym));
	  fseek(elf_fp, Shdr[offset].sh_offset, SEEK_SET);
	  ret = fread(sym, Shdr[offset].sh_size, 1, elf_fp);
	  assert(ret >= 1);
	  break;
	}
  }

  int sym_length = Shdr[offset].sh_size / sizeof(Elf32_Sym);
  for(int i = 0; i < sym_length; i++)
  {
	if(ELF32_ST_TYPE(sym[i].st_info) == STT_FUNC)
	{
	  char *p = &strarr[sym[i].st_name];
	  FUNC_table[func_top].addr = sym[i].st_value;
	  FUNC_table[func_top].size = sym[i].st_size;
	  int tmp_pos = 0;
	  while(*p)
		FUNC_table[func_top].name[tmp_pos ++] = *p++;
	  FUNC_table[func_top].name[tmp_pos] = '\0';
//	  printf("%s\n", FUNC_table[func_top].name);
	  func_top++;
	}
  }
}
