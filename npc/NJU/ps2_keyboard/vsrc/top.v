module top(
  input clk,
  input ps2_clk,
  input ps2_data,
  input rstn,
  output overflow,
  output [6:0] seg0,
  output [6:0] seg1,
  output [6:0] seg2,
  output [6:0] seg3,
  output [6:0] seg4,
  output [6:0] seg5,
  output [6:0] seg6,
  output [6:0] seg7
);

  parameter A = 0, B = 1, C = 2, D = 3;

  reg [2:0] state, next_state;
  wire        ready;
  reg         nextdata_n;
  wire [7:0]  data_kbd;    // FIFO直通输出（wire）
  reg  [7:0]  data_in;     // 锁存后的有效数据
  reg         fsm_valid;   // 本拍有新数据
  reg  [7:0]  prev_data;
  reg  [7:0]  use_data;
  reg         down;

  // ① PS/2 键盘模块（data_kbd 是 wire）
  ps2_keyboard kbd0(
    .clk      (clk),
    .clrn     (rstn),
    .ps2_clk  (ps2_clk),
    .ps2_data (ps2_data),
    .nextdata_n(nextdata_n),
    .data     (data_kbd),   // ← wire，不是 reg
    .ready    (ready),
    .overflow (overflow)
  );

  // ② nextdata_n 脉冲控制
  always @(posedge clk) begin
    if (~rstn)
      nextdata_n <= 1;
    else
      nextdata_n <= (ready && nextdata_n) ? 1'b0 : 1'b1;
  end

  // ③ 锁存数据 + 产生 fsm_valid
  always @(posedge clk) begin
    if (~rstn) begin
      data_in   <= 8'b0;
      fsm_valid <= 0;
    end else begin
      if (ready && nextdata_n) begin
        data_in   <= data_kbd;  // 锁存！
        fsm_valid <= 1;
      end else begin
        fsm_valid <= 0;
      end
    end
  end

  // ④ 次态逻辑（用 fsm_valid 门控，加默认值防环路）
  always @(*) begin
    next_state = state;   // 默认保持，消除环路
    case (state)
      A: next_state = !fsm_valid          ? A :
                      (data_in == 8'hF0)  ? D : B;

      B: next_state = !fsm_valid             ? B :
                      (data_in == 8'hF0)     ? D :
                      (data_in == prev_data) ? C : B;

      C: next_state = !fsm_valid             ? C :
                      (data_in == 8'hF0)     ? D :
                      (data_in == prev_data) ? C : B;

      D: next_state = !fsm_valid ? D : A;  // 等到Break后的扫描码再回A

      default: next_state = A;
    endcase
  end

  // ⑤ 状态寄存器
  always @(posedge clk) begin
    if (~rstn) begin
      state     <= A;
      prev_data <= 8'b0;
    end else begin
      if (state != next_state)
        $display("t=%0t  state %0d -> %0d  data=%02h", $time, state, next_state, data_in);
      state <= next_state;
      // 只在有效扫描码时更新 prev_data，0xF0 不记录
      if (fsm_valid && data_in != 8'hF0)
        prev_data <= data_in;
    end
  end

  // ⑥ 摩尔输出
  always @(*) begin
    down     = 1;
    use_data = 8'b0;
    case (state)
      B: begin use_data = data_in; down = 0; end
      C: begin use_data = data_in; down = 0; end
      default: begin use_data = 8'b0; down = 1; end
    endcase
  end

  // ⑦ BCD 显示
  bcd bcd0(
    .data    ({use_data[0], use_data[1], use_data[2], use_data[3],
               use_data[4], use_data[5], use_data[6], use_data[7]}),
    .clk     (clk),
    .down    (down),
    .bcd_low (seg0),
    .bcd_high(seg1)
  );

endmodule

