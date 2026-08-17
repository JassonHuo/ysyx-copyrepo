#include <klib.h>

#define N 10

uint8_t arr1[N];
uint8_t arr2[N];

void reset()
{
  for(int i = 0; i < N; i ++)
  {
	arr1[i] = N + i + 1;
	arr2[i] = N +i + 1;
  }
}
int main()
{
  reset();
  assert(memcmp(arr1, arr2, 0) == 0);
	for(int dis = -10; dis <= 10; dis ++)
	{
	  for(int i = 0; i < N; i ++)
	  {
		reset();
		arr1[i] += dis;
		int ret = memcmp(arr1, arr2, N);
//		printf("%d, %d\n", dis, ret);
		assert(ret == dis);
	  }
	}
  return 0;
}
