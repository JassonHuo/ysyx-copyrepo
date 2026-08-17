#include <klib.h>

#define N 10

uint8_t dst[N];

void reset()
{
  for(int i = 0; i < N; i ++)
	dst[i] = i + 1;
}

void check_seq(int l, int r, int val)
{
  for(int i = l; i < r; i++)
  {
//	printf("dst[i]: %d, val: %d\n", dst[i], val);
	assert(dst[i] == val + i - l);
  }
}

void check_eq(int l, int r, int val)
{
  for(int i = l; i < r; i++)
  {
	assert(dst[i] == val);
  }
}

int main()
{
  for(int l = 0; l < N; l ++)
  {
	for(int r = l + 1; r <= N; r ++)
	{
	  reset();
	  uint8_t val = (l + r) / 2;
	  uint8_t src[r - l];
	  for(int i = 0; i < r - l; i ++)
		src[i] = val;
	  memcpy(dst + l, src, r - l);
	  check_seq(0, l, 1);
	  check_eq(l, r, val);
	  check_seq(r, N - 1, r + 1);
	}
  }
  return 0;
}
