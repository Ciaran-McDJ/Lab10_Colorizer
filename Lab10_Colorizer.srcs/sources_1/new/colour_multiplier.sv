`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 03:42:53 PM
// Design Name: 
// Module Name: colour_multiplier
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


module colour_multiplier#(
    parameter int    WIDTH     = 128,
    parameter int    HEIGHT    = 128
) (
    input logic i_clk,
    input logic i_rst,
    
    // Signals with input_parser
    input logic i_converter_start,
    input logic [5:0] i_rgb_weights [3],

    // Signals with rgb_transmitter
    input logic i_transdata_waiting,
    output logic o_transdata_ready,
    output logic [7:0] o_pixel_data[3],

    // Signals with BRAM
    output logic [$clog2(WIDTH*HEIGHT)-1:0] o_mem_addr,
    input logic [7:0] i_mem_data
    );
endmodule
