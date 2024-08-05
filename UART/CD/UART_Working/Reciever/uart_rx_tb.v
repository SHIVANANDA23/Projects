`timescale 1ns / 1ps

module uart_rx_tb;

    // Constants
    parameter BITWIDTH = 8;
    parameter FINAL_VALUE = 196; // Match this with the transmitter

    // Signals for uart_rx
    reg clk;
    reg reset_n;
    reg rx;
    wire rx_done_tick;
    wire [BITWIDTH-1:0] rx_dout;

    // Signals for BGEN
    reg enable;
    wire s_tick;

    // Signals for buffer_r
    reg rd, wr, rst;
    reg [1:0] rpaddr;
    wire empty;
    wire [BITWIDTH-1:0] buffer_out;

    // Instantiate uart_rx
    uart_rx uart_rx_inst (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );

    // Instantiate BGEN
    BGEN #(.BITWIDTH(BITWIDTH)) bgen_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .FINAL_VALUE(FINAL_VALUE),
        .done(s_tick)
    );

    // Instantiate buffer_r
    buffer_r buffer_r_inst (
        .Clk(clk),
        .dataIn(rx_dout),
        .RD(rd),
        .WR(wr),
        .rpaddr(rpaddr),
        .dataOut(buffer_out),
        .Rst(rst),
        .EMPTY(empty)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period, 100MHz frequency
    end

    // Testbench logic
    initial begin
        // Initialize signals
        reset_n = 0;
        enable = 0;
        rx = 1;  // Idle state
        rd = 0;
        wr = 0;
        rst = 1;
        rpaddr = 2'b00;

        // Reset the system
        #20 reset_n = 1;
        #20 rst = 1;  // Deassert buffer reset

        // Enable BGEN
        #20 enable = 1;

        // Send data: Assume the same data as transmitter 8'hA5 = 10100101
        // Start bit
        #100 rx = 0;

        // Data bits (least significant bit first)
        #160 rx = 1;  // Bit 0
        #160 rx = 0;  // Bit 1
        #160 rx = 1;  // Bit 2
        #160 rx = 0;  // Bit 3
        #160 rx = 0;  // Bit 4
        #160 rx = 1;  // Bit 5
        #160 rx = 0;  // Bit 6
        #160 rx = 1;  // Bit 7

        // Stop bit
        #160 rx = 1;

        // Wait for reception to complete
       // wait(rx_done_tick);
        rst=0;
        // Write received data to buffer
        #20 wr = 1;
        #20 wr = 0;

        // Read data from buffer
        #20 rd = 1;
        #20 rd = 0;

        // Finish simulation
        //#1000 $finish;
    end

endmodule
