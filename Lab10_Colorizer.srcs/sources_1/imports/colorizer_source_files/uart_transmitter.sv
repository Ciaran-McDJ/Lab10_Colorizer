`timescale 1ns / 1ps

module uart_transmitter #(
    parameter int unsigned DATA_BITS = 8
) (
    input logic i_clk,
    input logic i_rst,

    input logic i_tick_16x,
    
    // UART line
    output logic o_uart_tx_out,  // idles high

    // TX interface
    input  logic                 i_transmit,  // pulse high for 1 cycle to start
    input  logic [DATA_BITS-1:0] i_data,
    output logic                 o_busy
  
);
    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        STOP,
        PAUSE
    } state_t;

    state_t state;

    logic [15:0] pause_timer;
    logic [3:0] tick_cnt;  // 0..15 for 16× timing per bit
    logic [$clog2(DATA_BITS):0] bit_idx;  // counts data bits
    logic [DATA_BITS-1:0] shreg;  // LSB-first shift register

    assign o_busy = (state != IDLE) || (state == IDLE && i_transmit);

    always_ff @(posedge i_clk) begin

        unique case (state)
            IDLE: begin
                o_uart_tx_out <= 1'b1;  // idle high
                if (i_transmit) begin
                    shreg <= i_data;
                    bit_idx <= '0;
                    tick_cnt <= '0;
                    state <= START;
                    o_uart_tx_out <= 1'b0;  // start bit
                end
            end


            START: begin
                if (i_tick_16x) begin
                    tick_cnt <= tick_cnt + 1'b1;
                    if (tick_cnt == 4'd15) begin
                        // move to first data bit
                        tick_cnt <= '0;
                        state <= DATA;
                        o_uart_tx_out <= shreg[0];
                    end
                end
            end


            DATA: begin
                if (i_tick_16x) begin
                    tick_cnt <= tick_cnt + 1'b1;
                    if (tick_cnt == 4'd15) begin
                        tick_cnt <= '0;
                        if (bit_idx == DATA_BITS - 1) begin
                            // last data bit just went out; next stop
                            state <= STOP;
                            o_uart_tx_out <= 1'b1;  // stop bit high
                        end else begin
                            bit_idx <= bit_idx + 1'b1;
                            shreg <= {1'b0, shreg[DATA_BITS-1:1]};  // shift right, LSB-first
                            o_uart_tx_out <= shreg[1];
                        end
                    end
                end
            end


            STOP: begin
                if (i_tick_16x) begin
                    tick_cnt <= tick_cnt + 1'b1;
                    if (tick_cnt == 4'd15) begin
                        tick_cnt <= '0;
                        state <= IDLE;
                        o_uart_tx_out <= 1'b1;
                    end
                end
            end

            // This pause state can be used to insert a small delay between transmissions. Useful for some cases.
            PAUSE: begin
                if (i_tick_16x) begin
                    pause_timer <= pause_timer + 1'b1;
                    if (pause_timer == 16) begin
                        pause_timer <= '0;
                        state <= IDLE;
                    end
                end
            end
            default: state <= IDLE;

        endcase

        if (i_rst) begin
            state <= IDLE;
            o_uart_tx_out <= 1'b1;
            tick_cnt <= '0;
            bit_idx <= '0;
            shreg <= '0;
            pause_timer <= '0;
        end

    end
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
endmodule
