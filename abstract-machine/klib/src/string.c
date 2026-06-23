#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

void segment_fault()
{
  printf("Segmentation fault (core dumped)\n");
//  exit(1);
  halt(1);
}

size_t strlen(const char *s) {
//  panic("Not implemented");
  if(s == NULL)
	segment_fault();
  size_t counter = 0;
  while(s[counter] != '\0')
  {
	counter ++;
  }
  return counter;
}

char *strcpy(char *dst, const char *src) {
//  panic("Not implemented");
  if(src == NULL || dst == NULL)
	segment_fault();
  int pos = 0;
  while(*(src + pos) != '\0')
  {
	*(dst + pos) = *(src + pos);
	pos++;
  }
  *(dst + pos) = *(src + pos);
  return dst;
}

char *strncpy(char *dst, const char *src, size_t n) {
//  panic("Not implemented");
  if(src == NULL || dst == NULL)
	segment_fault();
  bool is_NULL = false;
  for(int i = 0; i < n; i ++)
  {
	if(src[i] == '\0')
	  is_NULL = true;
	if(!is_NULL)
	  dst[i] = src[i];
	else
	  dst[i] = '\0';
  }
  return dst;
}

char *strcat(char *dst, const char *src) {
//  panic("Not implemented");
  if(src == NULL || dst == NULL)
	segment_fault();
  size_t pos_d = 0;
  while(dst[pos_d] != '\0')
	pos_d ++;
  size_t pos_s = 0;
  while(src[pos_s] != '\0')
  {
	dst[pos_d] = src[pos_s];
	pos_d ++;
	pos_s ++;
  }
  dst[pos_d] = '\0';
  return dst;
}

int strcmp(const char *s1, const char *s2) {
//  panic("Not implemented");
  if(s1 == NULL || s2 == NULL)
	segment_fault();
  int pos = 0;
  while(s1[pos] != '\0' && s2[pos] != '\0')
  {
	if(s1[pos] != s2[pos])
	  return s1[pos] - s2[pos];
	pos ++;
  }
  return s1[pos] - s2[pos];
}

int strncmp(const char *s1, const char *s2, size_t n) {
//  panic("Not implemented");
  if(s1 == NULL || s2 == NULL)
	segment_fault();
  for(int i = 0; i < n; i ++)
  {
	if(s1[i] != s2[i])
	  return s1[i] - s2[i];
	else if(s1[i] == '\0' || s2[i] == '\0')
	  return s1[i] - s2[i];
  }
  return 0;
}

void *memset(void *s, int c, size_t n) {
  panic("Not implemented");
}

void *memmove(void *dst, const void *src, size_t n) {
  panic("Not implemented");
}

void *memcpy(void *out, const void *in, size_t n) {
  panic("Not implemented");
}

int memcmp(const void *s1, const void *s2, size_t n) {
  panic("Not implemented");
}

#endif
