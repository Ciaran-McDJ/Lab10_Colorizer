`timescale 1ns / 1ps

module colorizer_top (
    input logic i_sys_clk,
    input logic i_sys_rst,

    // UART pins
    input  logic i_uart_rx_in,
    output logic o_uart_tx_out
);
    localparam int MEM_WIDTH = 128;
    localparam int MEM_HEIGHT = 128;

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
    
    proc_sys_reset_0 rst_gen (
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

    // Misc other signals
    logic tick_16x;

    // Signals between uart_receiver and input_parser
    logic [7:0] r_data;
    logic r_strobe;

    // Signals between input_parser and colour_converter
    logic converter_start;
    logic [6:0] rgb_weights[3];

    // Signals between our_colour_converter and memory_bram
    logic [$clog2(MEM_WIDTH*MEM_HEIGHT)-1:0] mem_addr;
    logic [7:0] mem_data;

    // Signals between our_colour_converter and uart_transmitter
    logic t_busy, t_transmit;
    logic [7:0] t_data;

    baud_gen our_baud_gen (
        .i_clk(clk),
        .i_rst(rst),
        .o_tick_16x(tick_16x)
    );

    uart_receiver our_uart_receiver (
        .i_clk(clk),
        .i_rst(rst),
        // Oversampling tick input (e.g., from uart_baud_gen)
        .i_tick_16x(tick_16x),
        // UART line
        .i_uart_rx_in(i_uart_rx_in),
        // Output data
        .o_data(r_data),
        .o_strobe(r_strobe)  // 1-cycle pulse when data valid
    );

    input_parser_top our_input_parser (
        .i_clk(clk),
        .i_rst(rst),
        // Signals with UART Receiver
        .i_r_data(r_data),
        .i_r_strobe(r_strobe),
        // Signals with colour_converter
        .o_converter_start(converter_start),
        .o_rgb_weights(rgb_weights)
    );
    
//    colour_converter_top #(
//        .WIDTH(MEM_WIDTH),
//        .HEIGHT(MEM_HEIGHT)
//    ) our_colour_converter (
//        .i_clk(clk),
//        .i_rst(rst),
//        // Signals with input_parser
//        .i_converter_start(converter_start),
//        .i_rgb_weights(rgb_weights),
//        // Signals with UART Transmitter
//        .i_t_busy(t_busy),
//        .o_t_data(t_data),
//        .o_t_transmit(t_transmit),
//        // Signals with BRAM
//        .o_mem_addr(mem_addr),
//        .i_mem_data(mem_data)
//    );

    memory_bram our_memory_bram (
        .i_clk(clk),
        .i_rst(rst),
        .i_addr(mem_addr),
        .o_data(mem_data)
    );

    uart_transmitter our_uart_transmitter (
        .i_clk(clk),
        .i_rst(rst),
        .i_tick_16x(tick_16x),
        // UART line
        .o_uart_tx_out(o_uart_tx_out),  // idles high
        // TX interface
        .i_transmit(t_transmit),  // pulse high for 1 cycle to start
        .i_data(t_data),
        .o_busy(t_busy)
    
    );
    
    ila_0 your_instance_name (
        .clk(clk), // input wire clk
    
    
       // .probe0(o_rgb_weights) // input wire [5:0]  probe0  
//        .probe1(probe1), // input wire [5:0]  probe1 
//        .probe2(probe2), // input wire [1:0]  probe2 
//        .probe3(probe3), // input wire [2:0]  probe3 
        .probe4(rgb_weights[0]), // input wire [0:0]  probe4 
        .probe5(rgb_weights[1]), // input wire [0:0]  probe5 
        .probe6(rgb_weights[2]) // input wire [0:0]  probe6
    );


endmodule
