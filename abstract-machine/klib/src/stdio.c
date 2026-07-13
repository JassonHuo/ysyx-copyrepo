#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

char buffer[64];
int buffer_top;

int printf(const char *fmt, ...) {
  panic("Not implemented");
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...)
{
  va_list args;
  va_start(args, fmt);
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
          out[out_pos++] = *(tmp++);
        }
	  }
	  else if(fmt[fmt_pos] == 'd')
      {
        char tmp[13];
        int tmp_pos = 0;
        int num = va_arg(args, int);
        if(num < 0)
		{
          out[out_pos++] = '-';
		  num = -num;
		}
		else if(num == 0)
		  out[out_pos++] = '0';
        while(num != 0)
        {
          tmp [tmp_pos++] = '0' + num % 10;
          num /= 10;
        }
		tmp[tmp_pos] = '\0';
        for(int i = 0; i < tmp_pos; i ++)
          out[out_pos++] = tmp[tmp_pos - 1 - i];
      }
      else
      {
        halt(1);
      }
    }
    else
    {
      out[out_pos++] = fmt[fmt_pos];
    }
    fmt_pos++;
  }
  out[out_pos] = '\0';
  va_end(args);
  return out_pos;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
