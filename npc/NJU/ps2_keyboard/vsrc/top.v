module top(
    input clk,
    input ps2_clk,
    input ps2_data,
    input rst,
    output overflow,
    output [6:0] seg0,
    output [6:0] seg1,
    output [6:0] seg2,
    output [6:0] seg3,
    output reg [7:0] data_out
);

    reg nextdata_n;
    wire [7:0] data_in;
    wire ready;

    ps2_keyboard pkbd(
        .clk(clk),
        .clrn(~rst),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .nextdata_n(nextdata_n),
        .data(data_in),
        .ready(ready),
        .overflow(overflow)
    );

    // 显示 result 的 ASCII 码（十六进制）
    bcd bcd0(
        .data(result),
        .clk(clk),
        .bcd_low(seg0),
        .bcd_high(seg1)
    );

    // 显示原始扫描码（十六进制，不反转）
    bcd bcd1(
        .data(data_in),
        .clk(clk),
        .bcd_low(seg2),
        .bcd_high(seg3)
    );

    reg [7:0] result;
    reg [7:0] valid_data;   // 过滤断码后的有效数据

    // 过滤断码：只保存非 0xF0 的数据
    always @(posedge clk) begin
        if (data_in != 8'hf0)
            valid_data <= data_in;
    end

    // 简单握手：只要 FIFO 非空，就不断读取
    assign nextdata_n = ~ready;   // 低有效：ready=1 时请求读取

    // 更新 result：在 valid_data 有效时（非断码）且 FIFO 被读取时更新
    // 由于 nextdata_n 连续拉低，每个时钟周期都会读取，我们需要在读取的同时更新 result
    // 为了确保只在 valid_data 真正有效时更新，我们可以使用 ready 的下降沿或使用 valid_data 的变化
    // 更简单：在 valid_data 变化时更新 result（但可能多次更新）
    // 推荐：使用 ready 的上升沿检测，但这里 nextdata_n 是组合逻辑，ready 可能变化很快
    // 采用同步逻辑：在时钟上升沿，如果 ready 为高（表示有数据），且当前 valid_data 有效，则更新 result
    reg ready_prev;
    always @(posedge clk) begin
        ready_prev <= ready;
        if (~rst) begin
            result <= 8'b0;
        end else if (ready && ~ready_prev) begin   // ready 上升沿，新数据到达
            // 使用 valid_data（已经过滤了断码）
            case(valid_data)
                8'h15: result <= "Q";
                8'h1d: result <= "W";
                8'h24: result <= "E";
                8'h2d: result <= "R";
                8'h2c: result <= "T";
                8'h35: result <= "Y";
                8'h3c: result <= "U";
                8'h43: result <= "I";
                8'h44: result <= "O";
                8'h4d: result <= "P";
                8'h1c: result <= "A";
                8'h1b: result <= "S";
                8'h23: result <= "D";
                8'h2b: result <= "F";
                8'h34: result <= "G";
                8'h33: result <= "H";
                8'h3b: result <= "J";
                8'h42: result <= "K";
                default: ;   // 保持原值
            endcase
        end
    end

    assign data_out = valid_data;   // 打印有效数据（过滤后的扫描码）

endmodule
