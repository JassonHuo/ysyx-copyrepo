module csr(
  input [11: 0] csr_raddr,
  input [11: 0] csr_waddr,
  input [31: 0] csr_wdata,
  input clk,
  input csr_en,
  input rst,
  output reg [31: 0] csr_rdata_out
);

  reg [31: 0] mcycle = 32'b0;
  reg [31: 0] mcycleh = 32'b0;

  always@(*)begin
	$display("%x", csr_raddr);
	case(csr_raddr)
	  12'hb00: csr_rdata_out = mcycle;
	  12'hb80: csr_rdata_out = mcycleh;
	  default: csr_rdata_out = 32'b0;
	endcase
  end

  always@(posedge clk)begin
	if(rst)begin
	  mcycle <= 0;
	  mcycleh <= 0;
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
