#include <klib.h>
#include <limits.h>

#define N 300

char out_buffer[N];
int data[] = {0, INT_MAX / 17, INT_MAX, INT_MIN, INT_MIN + 1,
              UINT_MAX / 17, INT_MAX / 17, UINT_MAX};

void d_check()
{
  char std_str[8][N] = {
	"test the int type: 0, 0, 000000, 000000, 0     ,      0, 0     ,      0",
	"test the int type: 126322567, -126322567, 126322567, -126322567, 126322567, 126322567, -126322567, -126322567",
	"test the int type: 2147483647, -2147483647, 2147483647, -2147483647, 2147483647, 2147483647, -2147483647, -2147483647", 
	"test the int type: -2147483648, -2147483648, -2147483648, -2147483648, -2147483648, -2147483648, -2147483648, -2147483648",
	"test the int type: -2147483647, 2147483647, -2147483647, 2147483647, -2147483647, -2147483647, 2147483647, 2147483647",
	"test the int type: 252645135, -252645135, 252645135, -252645135, 252645135, 252645135, -252645135, -252645135",
	"test the int type: 126322567, -126322567, 126322567, -126322567, 126322567, 126322567, -126322567, -126322567",
	"test the int type: -1, 1, -00001, 000001, -1    ,     -1, 1     ,      1",
  };
  for(int i = 0; i < 8; i ++)
  {
	uint32_t val = data[i];
	sprintf(out_buffer, "test the int type: %d, %d, %06d, %06d, %-6d, %6d, %-6d, %6d", val, -val, val, -val, val, val, -val, -val);
	if(strcmp(std_str[i], out_buffer))
	{
	  printf("%s\n", out_buffer);
	  printf("%s\n", std_str[i]);
	  assert(0);
	}
  }
}

void x_check()
{
  char std_str[8][N] = {
	"test the int type: 0, 0, 000000, 000000, 0     ,      0, 0     ,      0",
	"test the int type: 7878787, f8787879, 7878787, f8787879, 7878787, 7878787, f8787879, f8787879",
	"test the int type: 7fffffff, 80000001, 7fffffff, 80000001, 7fffffff, 7fffffff, 80000001, 80000001",
	"test the int type: 80000000, 80000000, 80000000, 80000000, 80000000, 80000000, 80000000, 80000000",
	"test the int type: 80000001, 7fffffff, 80000001, 7fffffff, 80000001, 80000001, 7fffffff, 7fffffff",
	"test the int type: f0f0f0f, f0f0f0f1, f0f0f0f, f0f0f0f1, f0f0f0f, f0f0f0f, f0f0f0f1, f0f0f0f1",
	"test the int type: 7878787, f8787879, 7878787, f8787879, 7878787, 7878787, f8787879, f8787879",
	"test the int type: ffffffff, 1, ffffffff, 000001, ffffffff, ffffffff, 1     ,      1"
  };
  for(int i = 0; i < 8; i ++)
  {
	uint32_t val = data[i];
	sprintf(out_buffer, "test the int type: %x, %x, %06x, %06x, %-6x, %6x, %-6x, %6x", val, -val, val, -val, val, val, -val, -val);
	if(strcmp(std_str[i], out_buffer))
	{
	  printf("%s\n", out_buffer);
	  printf("%s\n", std_str[i]);
	  assert(0);
	}
	assert(strcmp(std_str[i], out_buffer) == 0);
  }
}

void s_check()
{
  char std_str[N] = "test test this is a test of string type";
  sprintf(out_buffer, "test test %s", "this is a test of string type");
  assert(strcmp(std_str, out_buffer) == 0);
}

int main()
{
  d_check();
  x_check();
  s_check();
}
