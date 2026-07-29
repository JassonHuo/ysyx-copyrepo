module csr(
  input [11: 0] csr_raddr,
  input [11: 0] csr_waddr,
  input [31: 0] csr_wdata,
  input clk,
  input csr_en,
  input rst,
  output reg [31: 0] csr_rdata_out
);

  parameter ysyx_ascii = 32'h79737978;
  parameter ysyx_code = 32'd26060166;

  reg [31: 0] mcycle = 32'b0;
  reg [31: 0] mcycleh = 32'b0;
  reg [31: 0] mvendorid = ysyx_ascii;
  reg [31: 0] marchid = ysyx_code;
  reg [31: 0] mepc = 32'b0;
  reg [31: 0] mstatus = 32'h1800;
  reg [31: 0] mcause = 32'b0;

  always@(*)begin
	case(csr_raddr)
	  12'hb00: csr_rdata_out = mcycle;
	  12'hb80: csr_rdata_out = mcycleh;
	  12'hf11: csr_rdata_out = mvendorid;
	  12'hf12: csr_rdata_out = marchid;
	  12'h341: csr_rdata_out = mepc;
	  12'h342: csr_rdata_out = mcause;
	  12'h300: csr_rdata_out = mstatus;
	  default: csr_rdata_out = 32'b0;
	endcase
  end

  always@(posedge clk)begin
	if(rst)begin
	  mcycle <= 32'b0;
	  mcycleh <= 32'b0;
	  mvendorid <= ysyx_ascii;
	  marchid <= ysyx_code;
	end
	else begin
	  mcycle <= mcycle + 1;
	  mcycleh <= (mcycle == 32'hffffffff ? mcycleh + 1: mcycleh);
	  if(csr_en)begin
		case(csr_waddr)
		  12'hb00: mcycle <= csr_wdata;
		  12'hb80: mcycleh <= csr_wdata;
		  12'hf11: mvendorid <= csr_wdata;
		  12'hf12: marchid <= csr_wdata;
		  12'h341: mepc <= csr_wdata;
		  12'h342: mcause <= csr_wdata;
		  12'h300: mstatus <= csr_wdata;
		  default:begin
			npc_abort();
		  end
		endcase
	  end
	end
  end

endmodule
