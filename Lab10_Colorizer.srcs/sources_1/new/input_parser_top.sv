`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2026 12:46:33 PM
// Design Name: 
// Module Name: input_parser_top
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


module input_parser_top(
    input logic i_clk,
    input logic i_rst,

    // Signals with UART Receiver
    input logic [7:0] i_r_data,
    input logic i_r_strobe, // 1-cycle pulse when data valid

    // Signals with colour_converter
    output logic o_converter_start,
    output logic [5:0] o_rgb_weights [3] //3 values in array, red, then green, then blue
    );
endmodule
