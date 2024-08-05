`timescale 1ns/1ps

module BUFFER_T_Tb;

    // Constants
    parameter BITWIDTH = 8;
    parameter NUM_ADDRESSES = 4;
    
    // Signals
    reg tClk;
    reg tRD, tWR, tRst;
    reg [1:0] tpaddr;
    reg [BITWIDTH-1:0] tdataIn;
    wire tEMPTY, ttxrdy;
    wire [BITWIDTH-1:0] tdataOut;

    // Instantiate the module
    buffer_t dut (
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

    // Clock generation
    initial begin
        tClk = 0;
        forever #5 tClk = ~tClk;  // Generating a clock with a period of 10 time units
    end

    // Test case
    initial begin
        // Initialize signals
        tRD = 0;
        tWR = 0;
        tRst = 1;
        tpaddr = 0;
        tdataIn = 8'b10101010;  // Assigning a test input data

        // Reset the module
        #10 tRst = 0;  // Activate reset for 10 time units

        // Wait for a few clock cycles
        #20;  // Wait for 20 time units

        // Perform write operation to address 2
        tWR = 1;  // Activate write signal
        tpaddr = 2;  // Set address to 2
        tdataIn = 8'b11001100;  // Assign a different test input data
        #10 tWR = 0;  // Deactivate write signal after 10 time units

        // Wait for a few clock cycles
        #20;  

        // Write data to the buffer.
        tRst = 1;  
        tWR = 1;  
        tRD = 0;  
        #20;  // Wait for 20 time units

        // Perform read operation from address 2
        tRD = 1;  // Activate read signal
        #20 tRD = 0;  // Deactivate read signal after 20 time units

        // Wait for a few clock cycles
        #20;  

        // End simulation
        $finish;  // Finish simulation
    end

endmodule
