#include <klib.h>

#define N 10

char str[N];

void reset()
{
  for(int i = 0; i < N; i ++)
	str[i] = 'a' + i;
}

int main()
{
  for(int i = 0; i < N; i ++)
  {
	reset();
	str[i] = '\0';
	int ret = strlen(str);
	assert(ret == i);
  }
  return 0;
}
