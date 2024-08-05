`timescale 1ns / 1ps
`define IDLE 2'b00
`define SETUP 2'b11
`define R_ENABLE 2'b10
`define W_ENABLE 2'b01

module apbslave(
  input pclk,
  input presetn,
  input psel,
  input penable,
  input [1:0] P_ADDR,
  input pwrite,
  input [7:0] PW_DATA,
  input rx,
  input [7:0] datain,
  input [1:0] cs,  // Chip select signal
  output reg [7:0] Pr_data = 8'b0,
  output reg P_READY = 8'b1,
  output [7:0] o_baud_val,
  output [7:0] data_in,
  output TX_RDY,
  output RX_RDY,
  output RXOUT,
  input tf_TXRDY,
  input rbuff_RXRDY
);
  parameter BITWIDTH = 8;
  parameter SLAVE_COUNT = 2;  // Number of APB slave devices

  reg [7:0] mem[SLAVE_COUNT][0:3];  // Array of registers for each slave
  reg [1:0] state, next_state;
  reg rxout = 1'b1;
  reg txrdy = 1'b0;
  reg rxrdy = 1'b0;
  reg active_slave;  // Selected slave based on cs signal

  always @(negedge pclk, negedge presetn) begin
    if (!presetn) begin
      state <= `IDLE;
    end else begin
      state <= next_state;
      case (state)
        `IDLE: begin
          if (!presetn)
            next_state <= `IDLE;
          else
            next_state <= `SETUP;
        end
        `SETUP: begin
          if (psel) begin
            if (pwrite)
              next_state <= `W_ENABLE;
            else
              next_state <= `R_ENABLE;
          end else
            next_state <= `SETUP;
        end
        `W_ENABLE: begin
          if (psel && penable && pwrite)
            next_state <= `W_ENABLE;
          else
            next_state <= `IDLE;
        end
        `R_ENABLE: begin
          if (psel && penable && !pwrite)
            next_state <= `R_ENABLE;
          else
            next_state <= `IDLE;
        end
        default: begin
          next_state <= `IDLE;
        end
      endcase
    end
  end

  always @(negedge pclk) begin
    active_slave = cs;  // Select the active slave based on cs signal
  end

  always @(negedge pclk) begin
    for (int i = 0; i < SLAVE_COUNT; i = i + 1) begin
      case (state)
        `IDLE: begin
        end
        `SETUP: begin
          P_READY = 1'b0;
        end
        `W_ENABLE: begin
          if (psel && penable && pwrite && (P_ADDR == i) && (active_slave == i))
            mem[i][P_ADDR] <= PW_DATA;
          P_READY = (psel && penable && pwrite && (P_ADDR == i) && (active_slave == i)) ? 1'b1 : 1'b0;
        end
        `R_ENABLE: begin
          if (psel && penable && !pwrite && (P_ADDR == i) && (active_slave == i)) begin
            Pr_data = mem[i][P_ADDR];
            P_READY = 1'b1;
          end else
            P_READY = 1'b0;
        end
      endcase
    end
  end

  always @(negedge pclk) begin
    if (rx == 1'b0)
      rxout = 1'b0;
    else
      rxout = 1'b1;
  end

  always @(negedge pclk) begin
    if (tf_TXRDY == 1'b1)
      txrdy = 1'b1;
    else
      txrdy = 1'b0;
  end

  always @(negedge pclk) begin
    if (rbuff_RXRDY == 1'b1)
      rxrdy = 1'b1;
    else
      rxrdy = 1'b0;
  end

  assign RXOUT = rxout;
  assign o_baud_val = mem[0][0];
  assign data_in = mem[1][2];
  assign TX_RDY = txrdy;
  assign RX_RDY = rxrdy;

endmodule
