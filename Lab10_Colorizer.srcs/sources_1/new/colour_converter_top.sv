`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2026 12:46:33 PM
// Design Name: 
// Module Name: colour_converter_top
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


module colour_converter_top #(
    parameter int    WIDTH     = 128,
    parameter int    HEIGHT    = 128
) (
    input logic i_clk,
    input logic i_rst,
    
    // Signals with input_parser
    input logic i_converter_start,
    input logic [5:0] i_rgb_weights [3],

    // Signals with UART Transmitter
    input logic i_t_busy,
    output logic [7:0] o_t_data,
    output logic o_t_transmit,

    // Signals with BRAM
    output logic [$clog2(WIDTH*HEIGHT)-1:0] o_mem_addr,
    input logic [7:0] i_mem_data
    );
    // NOT BEING USED!!!!
endmodule
