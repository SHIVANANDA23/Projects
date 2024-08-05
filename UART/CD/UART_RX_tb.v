`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2023 17:49:38
// Design Name: 
// Module Name: UART_TX_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define BITWIDTH 8

module UART_TX_TB;
reg clk,reset;
reg rx;
wire done;
wire [`BITWIDTH-1 : 0] rx_dout;
wire rx_done_tick;
reg enable;
BAUD_GENERATE dut(.clk(clk),.reset_n(reset),.enable(enable),.done(done));
uart_rx uut(.clk(clk),.reset_n(reset),.rx(rx),.rx_done_tick(rx_done_tick),.rx_dout(rx_dout),.s_tick(done));
always #1 clk=~clk;
initial begin
clk=1;
reset=1;
enable=1;
#500 rx=0;
#400 rx=1;
#39500 $finish;
end

endmodule
