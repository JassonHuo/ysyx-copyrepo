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

  parameter NONE = 0, DOWN = 1, WAIT = 2;

  reg [1:0] state;
  wire ready;
  reg nextdata_n;
  wire [7:0] data_in;   // wire，接 ps2_keyboard 的 assign 输出
  reg [7:0] use_data;
  reg down;
  reg prev_ready;       // 上一拍的 ready，用于检测上升沿

  always @(posedge clk) begin
    if (!rstn) begin
      state      <= NONE;
      nextdata_n <= 1'b1;
      down       <= 1'b1;
      use_data   <= 8'b0;
      prev_ready <= 1'b0;
    end else begin
      // 默认值
      nextdata_n <= 1'b1;
      down       <= 1'b1;
      prev_ready <= ready;

      // 只在 ready 上升沿处理，保证每条数据只消费一次
      if (ready && !prev_ready) begin
        nextdata_n <= 1'b0;   // 单拍脉冲，通知 FIFO 移到下一条

        case (state)
          NONE: begin
            // ready 为高说明 FIFO 有数据，直接跳 DOWN
            state <= DOWN;
          end

          DOWN: begin
            down     <= 1'b0;
            use_data <= data_in;
            if (data_in == 8'hF0)
              state <= WAIT;
            else
              state <= DOWN;
          end

          WAIT: begin
            // F0 后面那个字节是 break code，消耗掉，回 NONE
            state <= NONE;
          end
        endcase
      end
    end
  end

  ps2_keyboard kbd0(
    .clk(clk),
    .clrn(rstn),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .nextdata_n(nextdata_n),
    .data(data_in),
    .ready(ready),
    .overflow(overflow)
  );

  bcd bcd0(
    .data({data_in[0], data_in[1], data_in[2],
           data_in[3], data_in[4], data_in[5],
           data_in[6], data_in[7]}),
    .clk(clk),
    .down(down),
    .bcd_low(seg0),
    .bcd_high(seg1)
  );

endmodule

