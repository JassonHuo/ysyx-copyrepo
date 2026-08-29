`define ALU_ADD 1
`define ALU_SUB 2
`define ALU_AND 3
`define ALU_OR  4
`define ALU_XOR 5
`define ALU_LEFT 6
`define ALU_RIGHT 7
`define ALU_LARGE 8
`define ALU_SMALL 9
`define ALU_EQUAL 10
`define ALU_NEQUAL 11
`define ALU_STOP 12
`define ALU_LAREQ 13

`define IDLE 0
`define WAIT_READY 1

`define CSR_NO 0
`define CSR_RC 1
`define CSR_RS 2
`define CSR_RCI 3
`define CSR_RW 4
`define CSR_RWI 5
`define CSR_RSI 6

`define ALU_IMM 0
`define ALU_RS2 1

`define RD_ALU 0
`define RD_IMM 1
`define RD_AUIPC 2
`define RD_PC 3
`define RD_MEM 4
`define RD_CSR 5

`define PC_NEXT 0
`define PC_JAL 1
`define PC_JALR 2
`define PC_BRANCH 3
`define PC_MTVEC 4
`define PC_MEPC 5

`define MEM_WORD 0
`define MEM_HALF 1
`define MEM_BYTE 2

`define SIZE1 0
`define SIZE2 1
`define SIZE4 2

`define BURST_FIXED 0
