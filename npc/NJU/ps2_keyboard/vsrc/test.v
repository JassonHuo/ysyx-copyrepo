module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  input rstn,
  output overflow,
  output [6:0] seg0, seg1, seg2, seg3,
  output [6:0] seg4, seg5, seg6, seg7
);

  parameter NONE = 0, DOWN = 1, WAIT = 2;

  reg [2:0] state;
  wire ready;
  reg nextdata_n;
  wire [7:0] data_kbd;
  reg down;
  reg [7:0] data_in;
  reg [15:0] counter;

  // ---- 同步 ready 并产生单周期读脉冲 ----
  reg ready_sync1, ready_sync2;
  reg ready_prev;
  wire read_pulse;                // 当拍为 1 表示有效读取时刻

  always @(posedge clk) begin
      ready_sync1 <= ready;           // 第一级同步
      ready_sync2 <= ready_sync1;     // 第二级同步（稳定后的 ready）
      ready_prev  <= ready_sync2;     // 上一拍的稳定 ready
  end
  assign read_pulse = ready_sync2 && ~ready_prev;  // 上升沿，只维持一个周期

  // ---- 核心控制逻辑 ----
  always @(posedge clk) begin
      $display("%d", state);
      if (!rstn) begin
          state      <= NONE;
          nextdata_n <= 1'b1;        // 不复位时拉高，不取数
          down       <= 1'b1;
          data_in    <= 8'h00;
          counter    <= 16'h0;
      end else begin
          // 默认保持 nextdata_n 为高，避免误触发 FIFO 出队
          nextdata_n <= 1'b1;

          if (read_pulse) begin
              // 这一拍拉低 nextdata_n，通知 FIFO 弹出数据
              nextdata_n <= 1'b0;
              // 注意：此时 data_kbd 还是旧值，新值将在下一个时钟沿呈现
          end else if (ready_sync2 && ~nextdata_n) begin
              // 上一拍我们拉低了 nextdata_n，FIFO 已经把新数据放到 data_kbd 上了
              // 这一拍采样数据并将 nextdata_n 恢复为高
              data_in    <= data_kbd;
              nextdata_n <= 1'b1;

              // ---- 状态机：使用刚采到的 data_kbd ----
              case (state)
                  NONE: begin
                      if (data_kbd == 8'h00) begin
                          state <= NONE;
                          down  <= 1'b1;
                      end else if (data_kbd == 8'hF0) begin
                          state <= WAIT;
                          down  <= 1'b1;
                      end else begin
                          state <= DOWN;
                          down  <= 1'b0;
                      end
                  end
                  DOWN: begin
                      if (data_kbd == 8'hF0) begin
                          state <= WAIT;
                          down  <= 1'b1;
                      end else begin
                          // 相同键的通码重复（typematic）只让 counter 累加
                          counter <= counter + 1;
                          state   <= DOWN;
                          down    <= 1'b0;
                      end
                  end
                  WAIT: begin
                      // 收到断码的第二字节（通常是通码），回到 NONE
                      if (data_kbd != 8'hF0 && data_kbd != 8'h00) begin
                          state <= NONE;
                          down  <= 1'b1;
                      end else begin
                          state <= WAIT;
                          down  <= 1'b1;
                      end
                  end
                  default: begin
                      state <= NONE;
                      down  <= 1'b1;
                  end
              endcase
          end
          // 如果没有读脉冲，且不在恢复期，就什么也不做，nextdata_n 保持 1
      end
  end

  // 实例化
  ps2_keyboard kbd0(
      .clk(clk), .clrn(rstn),
      .ps2_clk(ps2_clk), .ps2_data(ps2_data),
      .nextdata_n(nextdata_n), .data(data_kbd),
      .ready(ready), .overflow(overflow)
  );

  bcd bcd0(
      .data(data_in), .clk(clk), .down(down),
      .bcd_low(seg0), .bcd_high(seg1)
  );
  bcd bcd1(
      .data(counter[7:0]), .clk(clk), .down(1'b0),
      .bcd_low(seg4), .bcd_high(seg5)
  );
  bcd bcd2(
      .data(counter[15:8]), .clk(clk), .down(1'b0),
      .bcd_low(seg6), .bcd_high(seg7)
  );

endmodule
