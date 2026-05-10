module top(
  input rst,
  input clk,
  input ps2_data,
  input ps2_clk,
  output overflow,
  output reg [6:0] seg0, seg1, seg2, seg3,
  output reg [6:0] seg4, seg5, seg6, seg7
);

  reg nextdata_n;
  wire [7:0] data_kbd;
  wire ready;
  parameter NONE = 2'd0, PRESS = 2'd1, WAIT = 2'd2;

  reg [1:0] state;
  reg [7:0] data;
  reg rd_step;  // 0=空闲，1=等待数据出现的那个周期

  ps2_keyboard kbd(
    .clk(clk), .clrn(~rst),
    .ps2_clk(ps2_clk), .ps2_data(ps2_data),
    .nextdata_n(nextdata_n), .data(data_kbd),
    .ready(ready), .overflow(overflow)
  );

  always @(posedge clk) begin
    if (rst) begin
      state      <= NONE;
      data       <= 8'd0;
      nextdata_n <= 1'b1;
      rd_step    <= 1'b0;
    end else begin
      // 默认让 nextdata_n 保持高，防止意外弹出
      nextdata_n <= 1'b1;

      case (rd_step)
        1'b0: begin  // 空闲：等待 FIFO 里有新数据
          if (ready) begin
            nextdata_n <= 1'b0;   // 请求弹出
            rd_step    <= 1'b1;   // 下一拍采样
          end
        end

        1'b1: begin  // 数据已弹出，此时 data_kbd 是我们要的正确值
          data       <= data_kbd;   // 采样
          nextdata_n <= 1'b1;       // 结束读取
          rd_step    <= 1'b0;       // 回到空闲

          // ---- 状态机跳转，使用刚采样到的 data_kbd ----
          case (state)
            NONE: begin
              if (data_kbd == 8'd0)
                state <= NONE;
              else if (data_kbd == 8'hF0)
                state <= WAIT;
              else
                state <= PRESS;
            end

            PRESS: begin
              if (data_kbd == 8'hF0)
                state <= WAIT;
              else
                state <= PRESS;
            end

            WAIT: begin
              // 收到非 F0、非 0 的字节（即断码第二字节），表示完全释放
              if (data_kbd == 8'hF0 || data_kbd == 8'd0)
                state <= WAIT;
              else
                state <= NONE;
            end

            default: state <= NONE;
          endcase
        end
      endcase
    end
  end

  // 你可以在这里根据 state 和 data 驱动数码管，例如：
  // always @(*) begin
  //   if (state == PRESS) begin
  //     // 把 data 译码到 seg0~seg7
  //   end else begin
  //     // 全灭
  //   end
  // end

endmodule
