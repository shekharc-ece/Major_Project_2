
`timescale 1ns/1ps

module uart_tb;

    parameter CLKS_PER_BIT = 16;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    wire [7:0] rx_data;
    wire rx_done;

    integer errors;

    // UART Transmitter
    uart_tx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) tx_unit (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) rx_unit (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 50 MHz clock: 20 ns period
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Send one byte and verify reception
    task transmit_byte;
        input [7:0] data;
        begin
            @(negedge clk);
            tx_data = data;
            tx_start = 1'b1;

            @(negedge clk);
            tx_start = 1'b0;

            wait (rx_done == 1'b1);
            #1;

            if (rx_data === data) begin
                $display("PASS: Sent = %h, Received = %h",
                         data, rx_data);
            end
            else begin
                $display("FAIL: Sent = %h, Received = %h",
                         data, rx_data);
                errors = errors + 1;
            end

                       wait (tx_busy == 1'b0);
            repeat (2) @(negedge clk);
        end
    endtask
    initial begin

        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);

        rst = 1'b1;
        tx_start = 1'b0;
        tx_data = 8'h00;
        errors = 0;

        #100;
        rst = 1'b0;

        #100;

        $display("UART LOOPBACK TEST STARTED");

        transmit_byte(8'hA5);
        transmit_byte(8'h3C);
        transmit_byte(8'h00);
        transmit_byte(8'hFF);

        #100;

        if (errors == 0)
            $display("ALL UART TESTS PASSED");
        else
            $display("UART TEST FAILED: %0d errors", errors);

        $finish;
    end

endmodule

