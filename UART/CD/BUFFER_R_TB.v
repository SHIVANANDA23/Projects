`timescale 1ns/1ps

module BUFFER_R_TB;

    // Constants
    parameter BITWIDTH = 8;

    // Signals
    reg Clk;
    reg RD, WR, Rst;
    reg [1:0] rpaddr;
    reg [BITWIDTH-1:0] dataIn;
    wire EMPTY;
    wire [BITWIDTH-1:0] dataOut;

    // Instantiate the module
    BUFFER_R dut (
        .Clk(Clk),
        .RD(RD),
        .WR(WR),
        .rpaddr(rpaddr),
        .dataIn(dataIn),
        .Rst(Rst),
        .EMPTY(EMPTY),
        .dataOut(dataOut)
    );

    // Clock generation
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;  // Generating a clock with a period of 10 time units
    end

    // Test case
    initial begin
        // Initialize signals
        RD = 0;
        WR = 0;
        Rst = 1;
        rpaddr = 0;
        dataIn = 8'b10101010;  // Assigning a test input data

        // Reset the module
        #10 Rst = 0;  // Activate reset for 10 time units

        // Wait for a few clock cycles
        #20;  // Wait for 20 time units

        // Perform write operation to address 2
        WR = 1;  // Activate write signal
        RD=0;
        rpaddr = 2;  // Set address to 2
        dataIn = 8'b11001100;  // Assign a different test input data
        #10 WR = 0;  // Deactivate write signal after 10 time units

        // Wait for a few clock cycles
        #20;  // Wait for 20 time units

        // Perform read operation from address 2
        RD = 1;  // Activate read signal
        #40 RD = 0;  // Deactivate read signal after 20 time units

        // Wait for a few clock cycles
        #20;  // Wait for 20 time units

        // End simulation
        $finish;  // Finish simulation
    end

endmodule
