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


module colour_converter_top(
    input logic i_sys_clk,
    input logic i_sys_rst,
    
    // Signals with input_parser
    input logic i_start,
    input logic [5:0] i_weights [3],

    // Signals with UART Transmitter
    // TODO

    // Signals with BRAM
    // TODO
    
    );
endmodule
