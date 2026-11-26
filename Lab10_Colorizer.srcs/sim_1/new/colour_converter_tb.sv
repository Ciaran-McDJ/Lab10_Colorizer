`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2026 06:38:39 PM
// Design Name: 
// Module Name: colour_converter_tb
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


module colour_converter_tb();
    localparam int unsigned BAUD_PERIOD = 1 / 115200.0 * 1_000_000_000;  // in ns for 115200 baud
    localparam int unsigned CLOCK_PERIOD = 10; // in ns for 100MHz

    // These aren't used, as clk and rst are forced to overide the IP modules for the simulation
    logic sys_clk;
    logic sys_rst;

    // These are the ones we are using in the simulation
    logic clk;
    logic rst;
    logic start;
    logic [5:0] rgb_weights[3];

    // UART input and output signals
    logic uart_rx_in;
    logic uart_tx_out;

    // Generate the testbench clock
    always #(CLOCK_PERIOD/2) clk = ~clk;

    // Instantiate the DUT
    colorizer_top dut (
        .i_sys_clk(sys_clk),
        .i_sys_rst(sys_rst),
        .i_uart_rx_in(uart_rx_in),
        .o_uart_tx_out(uart_tx_out)
    );

    initial begin
        // forcing signals to only test the colour_converter
        force dut.clk = clk;
        force dut.rst = rst;
        force dut.rst = rst;
        force dut.converter_start = start;
        force dut.rgb_weights = rgb_weights;
        force dut.rst = rst;

        // Normal reset procedure
        clk = 0;
        rst = 1;
        start = 0;
        rgb_weights[0] = 6'd16; //Number from 0-30
        rgb_weights[1] = 6'd16; //Number from 0-30
        rgb_weights[2] = 6'd16; //Number from 0-30

        #100;
        rst = 0;
        #100;

        start = 1;



    end

endmodule
