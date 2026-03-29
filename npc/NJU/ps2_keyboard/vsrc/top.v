module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  input rstn,
  output overflow,
  output [6: 0] seg0,
  output [6: 0] seg1,
  output [6: 0] seg2,
  output [6: 0] seg3,
  output [6: 0] seg4,
  output [6: 0] seg5,
  output [6: 0] seg6,
  output [6: 0] seg7
);

  // 键盘状态机状态
  parameter NONE = 0, DOWN = 1, WAIT = 2;
  reg [1:0] state;

  // 握手状态机状态
  parameter HS_IDLE = 2'd0, HS_CONSUME = 2'd1, HS_WAIT = 2'd2;
  reg [1:0] handshake;

  wire ready;
  reg  nextdata_n;
  wire [7:0] data_in;
  reg  [7:0] use_data;
  reg  down;

  always @(posedge clk) begin
    if (!rstn) begin
      state      <= NONE;
      handshake  <= HS_IDLE;
      nextdata_n <= 1'b1;
      down       <= 1'b1;
      use_data   <= 8'b0;
    end
    else begin
      nextdata_n <= 1'b1;  // 默认拉高，只在CONSUME拍拉低

      case (handshake)

        // 等待FIFO有数据
        HS_IDLE: begin
          if (ready) begin
            use_data  <= data_in;   // 先锁存当前字节
            handshake <= HS_CONSUME;
          end
        end

        // 拉低nextdata_n一拍，推动r_ptr前进
        HS_CONSUME: begin
          nextdata_n <= 1'b0;
          handshake  <= HS_WAIT;
        end

        // 处理上一拍锁存的use_data，然后回到IDLE
        HS_WAIT: begin
          down <= 1'b1;  // 默认无按键

          case (state)
            NONE: begin
              if (use_data != 8'h00)
                state <= DOWN;
            end
            DOWN: begin
              if (use_data == 8'hF0) begin
                state <= WAIT;
              end else begin
                down  <= 1'b0;   // 有效通码，通知BCD显示
                state <= DOWN;
              end
            end
            WAIT: begin
              if (use_data != 8'h00)
                state <= NONE;
            end
          endcase

          handshake <= HS_IDLE;
        end

        default: handshake <= HS_IDLE;

      endcase
    end
  end

  ps2_keyboard kbd0(
    .clk       (clk),
    .clrn      (rstn),
    .ps2_clk   (ps2_clk),
    .ps2_data  (ps2_data),
    .nextdata_n(nextdata_n),
    .data      (data_in),
    .ready     (ready),
    .overflow  (overflow)
  );

  bcd bcd0(
    .data    (use_data),   // 用锁存值，而非data_in
    .clk     (clk),
    .down    (down),
    .bcd_low (seg0),
    .bcd_high(seg1)
  );

endmodule

