module ex(
  input [1: 0] opcode,
  input [1: 0] rd,
  input [1: 0] rs1, 
  input [1: 0] rs2,
  input [3: 0] imm,
  input [3: 0] addr,
  input [7: 0] rdata_in1,
  input [7: 0] rdata_in2,
  output reg wen,
  output reg [7: 0] wdata,
  output reg [1: 0] waddr,
  output reg [1: 0] raddr1,
  output reg [1: 0] raddr2,
  output reg pc_en,
  output reg [3: 0] pc_addr_out,
  input [7: 0] reg2,
  output [7: 0] out_num
);

  always@(*)begin
	wen = 0;
	wdata = 0;
	waddr = 0;
	raddr1 = 0;
	raddr2 = 0;
	pc_en = 0;
	pc_addr_out = 0;
	case(opcode)
	  2'b00: begin
		wen = 1;
		wdata = rdata_in1 + rdata_in2;
		raddr1 = rs1;
		raddr2 = rs2;
		waddr = rd;
		out_num = 0;
	  end
	  2'b10: begin
		wen = 1;
		waddr = rd;
		wdata = {{4{1'b0}}, imm};	
		out_num = 0;
	  end	
	  2'b11: begin
		wen = 0;
		raddr1 = 0;
		raddr2 = rs2;
		if(rdata_in1 != rdata_in2)begin
		  pc_en = 1;
		  pc_addr_out = addr;
		end
		out_num = 0;
	  end
	  2'b01: begin
		out_num = reg2;
	  end
	  default:begin
		wen = 0;
   		wdata = 0;
   		waddr = 0;
   		raddr1 = 0;
   		raddr2 = 0;
   		pc_en = 0;
   		pc_addr_out = 0;
		out_num = 0;
	  end
	endcase
  end

endmodule
