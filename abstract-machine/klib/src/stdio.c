#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

char buffer[64];
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
int PRINT(char *out, const char* fmt, va_list args)
{
  int fmt_pos = 0;
  int out_pos = 0;
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
#ifdef STD_PRINTF
		  putch(*(tmp++));
#else
          out[out_pos++] = *(tmp++);
#endif
        }
	  }
	  else if(fmt[fmt_pos] == 'd')
      {
        char tmp[13];
        int tmp_pos = 0;
        int num = va_arg(args, int);
        if(num < 0)
		{
#ifdef STD_PRINTF
		  putch('-');
#else
          out[out_pos++] = '-';
#endif
		  num = -num;
		}
		else if(num == 0)
#ifdef STD_PRINTF
		  putch('0');
#else
		  out[out_pos++] = '0';
#endif
        while(num != 0)
        {
          tmp [tmp_pos++] = '0' + num % 10;
          num /= 10;
        }
		tmp[tmp_pos] = '\0';
        for(int i = 0; i < tmp_pos; i ++)
#ifdef STD_PRINTF
		  putch(tmp[tmp_pos - 1 - i]);
#else
          out[out_pos++] = tmp[tmp_pos - 1 - i];
#endif
      }
      else
      {
        halt(1);
      }
    }
    else
    {
#ifdef STD_PRINTF
	  putch(fmt[fmt_pos]);
#else
      out[out_pos++] = fmt[fmt_pos];
#endif
    }
    fmt_pos++;
  }
#ifndef STD_PRINTF
  out[out_pos] = '\0';
#endif
  return out_pos;
}

int printf(const char *fmt, ...) {
//  panic("Not implemented");
  char *tmp = NULL;
  va_list args;
  va_start(args, fmt);
#define STD_PRINTF
  int ret = PRINT(tmp, fmt, args);
#undef STD_PRINTF
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
  int ret = PRINT(out, fmt, args);
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
