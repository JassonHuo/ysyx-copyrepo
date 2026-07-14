#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

char buffer[1000];
int buffer_top;


/*
int printf(const char *fmt, ...) {
//  panic("Not implemented");
  char *tmp = NULL;
#define STD_PRINTF
  int ret = sprintf(tmp, fmt, __VA_ARGS__);
#undef STD_PRINTF
  return ret;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

//int sprintf(char *out, const char *fmt, ...)
//{
*/
int PRINT(const char* fmt, va_list args)
{
  int fmt_pos = 0;
  int buffer_pos = 0;
  while(fmt[fmt_pos] != '\0')
  {
    if(fmt[fmt_pos] == '%')
    {
      fmt_pos ++;
      if(fmt[fmt_pos] == 's')
      {
        char *tmp = va_arg(args, char*);
        while(*tmp != '\0')
        {
          buffer[buffer_pos++] = *(tmp++);
        }
	  }
	  else if(fmt[fmt_pos] == 'd')
      {
        char tmp[13];
        int tmp_pos = 0;
        int num = va_arg(args, int);
		unsigned int abs_num = num;
        if(num < 0)
		{
          buffer[buffer_pos++] = '-';
		  abs_num = ~((unsigned int)num) + 1;
		}
		else if(num == 0)
		{
		  buffer[buffer_pos++] = '0';
		}
        while(abs_num != 0)
        {
          tmp [tmp_pos++] = '0' + abs_num % 10;
          abs_num /= 10;
        }
		tmp[tmp_pos] = '\0';
        for(int i = 0; i < tmp_pos; i ++)
		{
          buffer[buffer_pos++] = tmp[tmp_pos - 1 - i];
		}
      }
      else
      {
        halt(1);
      }
    }
    else
    {
      buffer[buffer_pos++] = fmt[fmt_pos];
    }
    fmt_pos++;
  }
  buffer[buffer_pos] = '\0';
  return buffer_pos;
}

int printf(const char *fmt, ...) {
//  panic("Not implemented");
  va_list args;
  va_start(args, fmt);
  int ret = PRINT(fmt, args);
  for(int i = 0; ;i++)
  {
	if(buffer[i] == '\0')
	  break;
	putch(buffer[i]);
  }
  va_end(args);
  return ret;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...)
{
  va_list args;
  va_start(args, fmt);
  int ret = PRINT(fmt, args);
  int i;
  for(i = 0; ; i++)
  {
	if(buffer[i] == '\0')
	  break;
	out[i] = buffer[i];
  }
  out[i] = '\0';
  va_end(args);
  return ret;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
