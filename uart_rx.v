
module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

    parameter CLKS_PER_BIT = 5208;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] rx_shift_reg;

    reg rx_sync1;
    reg rx_sync2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;
        end
        else begin
            rx_sync1 <= rx;
            rx_sync2 <= rx_sync1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            rx_shift_reg <= 0;
            rx_data <= 0;
            rx_done <= 0;
        end
        else begin

            rx_done <= 1'b0;

            case (state)

                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;

                    if (rx_sync2 == 1'b0)
                        state <= START;
                end

                START: begin
                    if (clk_count < (CLKS_PER_BIT/2 - 1))
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;

                        if (rx_sync2 == 1'b0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        rx_shift_reg[bit_index] <= rx_sync2;

                        if (bit_index < 7)
                            bit_index <= bit_index + 1;
                        else
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (clk_count < CLKS_PER_BIT - 1)
                        clk_count <= clk_count + 1;
                    else begin
                        clk_count <= 0;
                        state <= IDLE;

                        if (rx_sync2 == 1'b1) begin
                            rx_data <= rx_shift_reg;
                            rx_done <= 1'b1;
                        end
                    end
                end

                default: begin
                    state <= IDLE;
                    clk_count <= 0;
                end

            endcase
        end
    end

endmodule


