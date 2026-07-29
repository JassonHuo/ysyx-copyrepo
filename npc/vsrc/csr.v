module csr(
  input [11: 0] csr_raddr,
  input [11: 0] csr_waddr,
  input [31: 0] csr_wdata,
  input [31: 0] mepc_in,
  input [31: 0] mcause_in,
  input clk,
  input csr_en,
  input rst,
  input yield_csren,
  output reg [31: 0] csr_rdata_out,
  output [31: 0] mtvec_out,
  output [31: 0] mepc_out
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
  reg [31: 0] mtvec = 32'b0;


  assign mtvec_out = mtvec;
  assign mepc_out = mepc;
  always@(*)begin
	case(csr_raddr)
	  12'hb00: csr_rdata_out = mcycle;
	  12'hb80: csr_rdata_out = mcycleh;
	  12'hf11: csr_rdata_out = mvendorid;
	  12'hf12: csr_rdata_out = marchid;
	  12'h341: csr_rdata_out = mepc;
	  12'h342: csr_rdata_out = mcause;
	  12'h300: csr_rdata_out = mstatus;
	  12'h305: csr_rdata_out = mtvec;
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
		  12'h341: mepc <= (yield_csren ? mepc_in: csr_wdata);
		  12'h342: mcause <= (yield_csren ? mcause_in: csr_wdata);
		  12'h300: mstatus <= csr_wdata;
		  12'h305: begin
//			$display("mtvec: %08x", mtvec);
//			$display("wcsrdata: %08x", csr_wdata);
			mtvec <= csr_wdata;
		  end
		  default:begin
			mcycle <= mcycle;
			mcycleh <= mcycleh;
			mvendorid <= mvendorid;
			marchid <= marchid;
			mepc <= mepc;
			mcause <= mcause;
			mstatus <= mstatus;
			mtvec <= mtvec;
		  end
		endcase
	  end
	end
  end

endmodule
