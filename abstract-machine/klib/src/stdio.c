#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

char buffer[64];
int buffer_top;

int itoa(int num)
{
  if(num == 0)
  {
	buffer[0] = '0';	
	return 1;
  }
  int counter = 0;
  char tmp[64] = {0}; 
  int tmp_top = 0;
  while(num != 0)
  {
	tmp[counter] = num % 10;
	num /= 10;
	tmp_top ++;
  }
  counter = tmp_top;
  while(tmp_top)
	buffer[buffer_top ++] = tmp[tmp_top--];
  return counter;
}

int printf(const char *fmt, ...) {
  panic("Not implemented");
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...) {
//  panic("Not implemented");
  va_list ap;
  va_start(ap, fmt);
  int pos = 0;
  while(fmt[pos] != '\0')
  {
	if(fmt[pos] == '%')
	{
	  if(fmt[++pos] == 'd')
	  {
		int num = va_arg(ap, int);
		itoa(num);
		char *s = buffer;
		while(*s != '\0')
		{
		  out[++pos] = *s++;
		}
		out[++pos] = '\0';
	  }
	  else if(fmt[++ pos] == 's')
	  {
		char *s = va_arg(ap, char*);
		while(*s != '\0')
		{
		  out[++pos] = *s++;
		}
		out[++pos] = '\0';
	  }
	  else
	  {
		printf("Unknown type\n");
		halt(1);
	  }
	}
	pos ++;
  }
  va_end(ap);
  return 0;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
