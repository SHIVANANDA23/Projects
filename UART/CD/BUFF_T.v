`timescale 1ns / 1ps  // Defines the simulation timescale (1ns for time unit, 1ps for precision)
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:16:37 03/27/2023
// Design Name:
// Module Name:    buffer_t
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

`define BITWIDTH 8  // Defines a macro BITWIDTH with value 8

module buffer_t( tClk, tdataIn, tRD, tWR, tpaddr, tdataOut, tRst, tEMPTY, ttxrdy);  

 input tClk, tRD, tWR, tRst;  // Input ports: clock, read signal, write signal, reset
 input [1:0] tpaddr;  // Input port: address bus (2 bits)
 output tEMPTY, ttxrdy;  // Output ports: buffer empty status, transmit ready status
 input [`BITWIDTH-1:0] tdataIn;  // Input port: data input
 output reg [`BITWIDTH-1:0] tdataOut;  // Output port: data output

 assign tEMPTY = (!tWR && tRD) ? 1'b0 : 1'b1; // Evaluates if the buffer is empty or not based on control signals
 assign ttxrdy = (!tRst) ? 1'b0 : 1'b1; // Evaluates the data buffer status based on the reset signal

 reg [`BITWIDTH-1:0] mem[3:0]; // Declares a 4-entry memory, each entry holding data of width defined by BITWIDTH

 always @(posedge tClk)  // Sensitivity to positive edge of tClk
 begin
    if (tRst) begin  // If reset signal is active
        if (tWR && !tRD) begin  // If write signal is active and read signal is inactive
            mem[tpaddr] = tdataIn;  // Write dataIn to the buffer at address tpaddr
        end
        else if (tRD) begin  // If read signal is active
            tdataOut = mem[tpaddr];  // Read data from the buffer at address tpaddr and assign to tdataOut
        end
        else;  // In other cases, do nothing
    end
 end

endmodule
