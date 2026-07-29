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

  always@(*)begin
	case(csr_raddr)
	  12'hb00: csr_rdata_out = mcycle;
	  12'hb80: csr_rdata_out = mcycleh;
	  12'hf11: csr_rdata_out = mvendorid;
	  12'hf12: csr_rdata_out = marchid;
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
		  default:begin

		  end
		endcase
	  end
	end
  end

endmodule
