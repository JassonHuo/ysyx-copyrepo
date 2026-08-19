#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

char buffer[1000];
int buffer_top;

int PRINT(const char *fmt, va_list args)
{
  buffer_top = 0;
  for(int fmt_pos = 0; fmt[fmt_pos]; fmt_pos ++)
  {
	bool left_align = 0;
	bool zero_pad = 0;
	int width = 0;
	int total_len = 0;
	int point_acc = 0;
	char fill_char = '\0';
	if(fmt[fmt_pos] != '%')
	{
	  buffer[buffer_top ++] = fmt[fmt_pos];
	  continue;
	}
	fmt_pos ++;
	if(fmt[fmt_pos] == '-')
	{
	  left_align = 1;
	  fmt_pos ++;
	}
	else if(fmt[fmt_pos] == '0')
	{
	  zero_pad = 1;
	  fmt_pos++;
	}
	while(fmt[fmt_pos] >= '0' && fmt[fmt_pos] <= '9')
	  width = width * 10 + fmt[fmt_pos++] - '0';
	if(fmt[fmt_pos] == '.')
	{
	  fmt_pos ++;
	  while(fmt[fmt_pos] >= '0' && fmt[fmt_pos] <= '9')
	  {
		point_acc = point_acc * 10 + fmt[fmt_pos] - '0';
		fmt_pos ++;
	  }
	}
	if(fmt[fmt_pos] == 'c')
	  buffer[buffer_top++] = va_arg(args, int);
	else if(fmt[fmt_pos] == 's')
	{
	  char *s = va_arg(args, char*);
	  while(*s)
		buffer[buffer_top ++] = *s++;
	}
	else if(fmt[fmt_pos] == 'd'|| fmt[fmt_pos] == 'x' || (fmt[fmt_pos] == 'l' && fmt[fmt_pos + 1] == 'd') || fmt[fmt_pos] == 'p' || fmt[fmt_pos] == 'b')
	{
	  long long num;
	  unsigned long long abs_num;
	  int sign = 0;
	  int x0 = 0;
	  char tmp[100] = "";
	  if(fmt[fmt_pos] == 'd' || fmt[fmt_pos] == 'x' || fmt[fmt_pos] == 'b')
		num = (long long)va_arg(args, int);
	  else if(fmt[fmt_pos] == 'l')
	  {
		num = (long long)va_arg(args, long);
		fmt_pos ++;
	  }
	  else if(fmt[fmt_pos] == 'p')
		num = (long long)(uintptr_t)va_arg(args, void*);
	  if(fmt[fmt_pos] != 'b' && fmt[fmt_pos] != 'p' && fmt[fmt_pos] != 'x' && num < 0)
	  {
		sign = 1;
		abs_num = (unsigned long long)-num;
	  }
	  else if(fmt[fmt_pos] == 'x' || fmt[fmt_pos] == 'b')
		abs_num = (unsigned long long)(unsigned int)num;
	  else if(fmt[fmt_pos] == 'p')
	  {
		x0 = 1;
		abs_num = (unsigned long long)num;
	  }
	  else
		abs_num = (unsigned long long)num;
	  int len = 0;
	  if(abs_num == 0)
		tmp[len ++] = '0';
	  else
	  {
		char digits[] = "0123456789abcdef";
		int scale = (fmt[fmt_pos] == 'p' || fmt[fmt_pos] == 'x' ? 16: 
			(fmt[fmt_pos] == 'b' ? 2: 10));
		while(abs_num > 0)
		{
		  tmp[len ++] = digits[abs_num % scale];
		  abs_num /= scale;
		}
		if(x0)
		{
		  tmp[len ++] = 'x';
		  tmp[len ++] = '0';
		}
	  }
	  total_len = len + sign + point_acc + (point_acc ? 1: 0);
	  fill_char = (zero_pad && !left_align) ? '0' : ' ';
	  if(!left_align)
	  {
		if(sign && zero_pad)
		  buffer[buffer_top++] = '-';
		for(int i = total_len; i < width; i ++)
		  buffer[buffer_top++] = fill_char;
	  }
	  if(sign && (!zero_pad || left_align))
		buffer[buffer_top++] = '-';
	  for(int j = len - 1; j >= 0; j --)
		buffer[buffer_top++] = tmp[j];
	  if(point_acc)
		buffer[buffer_top++] = '.';
	  for(int i = 0; i < point_acc; i++)
		buffer[buffer_top++] = '0';
	  if(left_align)
		for(int i = total_len; i < width; i ++)
		  buffer[buffer_top++] = ' ';
	}
	else
	  halt(1);
  }
  buffer[buffer_top] = '\0';
  return buffer_top;
}

int printf(const char *fmt, ...) {
    // panic("Not implemented");
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
