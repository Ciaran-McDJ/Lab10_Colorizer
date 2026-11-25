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
    parameter int unsigned DATA_BITS = 8
) (
    input logic i_clk,
    input logic i_rst,
    
    // Signals with input_parser
    input logic i_start,
    input logic [5:0] i_weights [3],

    // Signals with UART Transmitter
    input logic i_t_busy,
    output logic [DATA_BITS-1:0] o_t_data,
    output logic o_t_transmit,

    // Signals with BRAM
    output logic o_mem_addr,
    input logic i_mem_data
    );
endmodule
