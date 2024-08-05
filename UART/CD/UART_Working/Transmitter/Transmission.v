`timescale 1ns / 1ps

module Transmission;

    // Constants
    parameter BITWIDTH = 8;
    parameter FINAL_VALUE = 196; // Adjust this to match the baud rate

    // Signals for BGEN
    reg clk;
    reg reset_n;
    reg enable;
    reg [BITWIDTH-1:0] FINAL_VALUE_REG;
    wire s_tick;

    // Signals for buffer_t
    reg tClk;
    reg tRD, tWR, tRst;
    reg [1:0] tpaddr;
    reg [BITWIDTH-1:0] tdataIn;
    wire tEMPTY, ttxrdy;
    wire [BITWIDTH-1:0] tdataOut;

    // Signals for uart_tx
    reg tx_start;
    wire tx_done_tick;
    wire tx;

    // Instantiate BGEN
    BGEN #(.BITWIDTH(BITWIDTH)) bgen_inst (
        .clk(clk),
        .reset_n(reset_n),
        .enable(enable),
        .FINAL_VALUE(FINAL_VALUE_REG),
        .done(s_tick)
    );

    // Instantiate buffer_t
    buffer_t buffer_inst (
        .tClk(tClk),
        .tRD(tRD),
        .tWR(tWR),
        .tpaddr(tpaddr),
        .tdataIn(tdataIn),
        .tRst(tRst),
        .tEMPTY(tEMPTY),
        .ttxrdy(ttxrdy),
        .tdataOut(tdataOut)
    );

    // Instantiate uart_tx
    uart_tx uart_tx_inst (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(tx_start),
        .s_tick(s_tick),
        .tx_din(tdataOut),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // Clock generation for clk
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period, 100MHz frequency
    end

    // Clock generation for tClk
    initial begin
        tClk = 0;
        forever #5 tClk = ~tClk;  // 10ns period, 100MHz frequency
    end

    // Testbench logic
    initial begin
        // Initialize signals
        reset_n = 0;
        enable = 0;
        FINAL_VALUE_REG = FINAL_VALUE;
        tRst = 1;
        tWR = 0;
        tRD = 0;
        tpaddr = 2'b00;
        tdataIn = 8'hA5;
        tx_start = 0;

        // Reset the system
        #20 reset_n = 1;
        #20 tRst = 1;  // Deassert reset

        // Write data to buffer
        #10 tWR = 1;  // Activate write signal
            tpaddr = 2'b00;  // Address 0
            tdataIn = 8'hA5;  // Data to write
        #10 tWR = 0;  // Deactivate write signal

        // Wait for a few clock cycles
        #20;

        // Read data from buffer
       // tRst=0;
        #10 tRD = 1;  // Activate read signal
            tpaddr = 2'b00;  // Address 0
        //#10 tRD = 0;  // Deactivate read signal

        // Wait for a few clock cycles to ensure data is read
        #20;

        // Enable BGEN
        #10 enable = 1;

        // Start UART transmission
        #10 tx_start = 1;
        #10 tx_start = 0;

        // Wait for UART transmission to complete
        #1000000;

        // Finish simulation
        $finish;
    end

endmodule
