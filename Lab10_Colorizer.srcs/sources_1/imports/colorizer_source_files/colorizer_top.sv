`timescale 1ns / 1ps

module colorizer_top (
    input logic i_sys_clk,
    input logic i_sys_rst,

    // UART pins
    input  logic i_uart_rx_in,
    output logic o_uart_tx_out
);
    logic clk, rst, locked;

    clk_wiz_0 clk_wiz (
        // Clock out ports
        .clk_out1(clk),     // output clk_out1
        // Status and control signals
        .reset(rst), // input reset
        .locked(locked),       // output locked
       // Clock in ports
        .clk_in1(i_sys_clk)      // input clk_in1
    );
    
    proc_sys_reset_0 rst_gen
    (
      .slowest_sync_clk(clk),
      .ext_reset_in(i_sys_rst),
      .aux_reset_in('0),
      .mb_debug_sys_rst('0),
      .dcm_locked(locked),    
      .mb_reset(),
      .bus_struct_reset(),
      .peripheral_reset(rst),
      .interconnect_aresetn(), 
      .peripheral_aresetn() 
    );





    // colour_converter_top our_colour_converter (
    // .i_clk,
    // input logic i_rst,
    
    // // Signals with input_parser
    // input logic i_start,
    // input logic [5:0] i_weights [3],

    // // Signals with UART Transmitter
    // input logic i_t_busy,
    // output logic [DATA_BITS-1:0] o_t_data,
    // output logic o_t_transmit,

    // // Signals with BRAM
    // output logic o_mem_addr,
    // input logic i_mem_data
    // );



endmodule
