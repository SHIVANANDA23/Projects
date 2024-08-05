`timescale 1ns / 1ps
`define BITWIDTH 8

module BAUD_GENERATE (
    input clk,              // Clock input
    input reset_n,          // Reset input (active-low)
    input enable,           // Enable signal
    input [`BITWIDTH - 1 : 0] FINAL_VALUE,  // Final value to compare against
    output reg done         // Done output signal
);

    reg [`BITWIDTH - 1 : 0] Q_reg = 0, Q_next = 0;  // Registers to hold current and next values

    // Sequential logic for updating Q_reg
    always @(posedge clk or negedge reset_n)
    begin
        if (~reset_n)       // Reset condition
            Q_reg <= 'b0;
        else if (enable)    // When enable is active
            Q_reg <= Q_next; // Update Q_reg with Q_next
        // If enable is inactive, retain Q_reg
    end

    // Assignment to 'done' indicating completion of the count
    assign done = (Q_reg == FINAL_VALUE);

    // Sequential logic for updating Q_next on negative edge of clk
    always @(negedge clk)
        Q_next = (done) ? 1'b0 : (Q_reg + 1'b1);  // Reset to 0 if done, else increment Q_reg

endmodule
