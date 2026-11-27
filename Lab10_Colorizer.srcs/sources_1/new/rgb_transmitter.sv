`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 03:42:53 PM
// Design Name: 
// Module Name: rgb_transmitter
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


module rgb_transmitter(
    input logic i_clk,
    input logic i_rst,

    //Signals with colour_multiplier
    output logic o_transdata_waiting,
    input logic i_transdata_ready,
    input logic [7:0] i_pixel_data[3],
    
    // Signals with uart_transmitter
    input logic i_t_busy,
    output logic [7:0] o_t_data,
    output logic o_t_transmit
    );
endmodule
