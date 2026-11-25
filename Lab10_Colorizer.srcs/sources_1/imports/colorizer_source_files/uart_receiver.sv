`timescale 1ns / 1ps

module uart_receiver #(
    parameter int unsigned DATA_BITS = 8
) (
    input logic i_clk,
    input logic i_rst,

    // Oversampling tick input (e.g., from uart_baud_gen)
    input logic i_tick_16x,

    // UART line
    input logic i_uart_rx_in,  // asynchronous RX line (idles high)

    // Output data
    output logic [DATA_BITS-1:0] o_data,
    output logic                 o_strobe  // 1-cycle pulse when data valid
);

    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;
    state_t state;

    logic [3:0] tick_cnt;  // 0..15 oversample counter within a bit
    logic [$clog2(DATA_BITS):0] bit_idx;
    logic [DATA_BITS-1:0] shreg;
    logic samp;

    // 2FF synchronizer for RX line
    (* async_reg = "true" *) logic rx_meta, uart_rx_in_sync;
    always_ff @(posedge i_clk) begin
        rx_meta <= i_uart_rx_in;
        uart_rx_in_sync <= rx_meta;
    end

    always_ff @(posedge i_clk) begin
        o_strobe <= 1'b0;

        unique case (state)
            IDLE: begin
                // wait for start edge (high->low)
                if (uart_rx_in_sync == 1'b0) begin
                    state    <= START;
                    tick_cnt <= 4'd0;
                end
            end

            START: begin
                if (i_tick_16x) begin
                    tick_cnt <= tick_cnt + 1'b1;

                    if (tick_cnt == 4'd8) begin
                        if (uart_rx_in_sync == 1'b0) begin
                            state    <= DATA;
                            tick_cnt <= '0;
                            bit_idx  <= '0;
                        end else begin
                            // false start bit (glitch)
                            state <= IDLE;
                        end
                    end
                end
            end

            DATA: begin
                if (i_tick_16x) begin
                    tick_cnt <= tick_cnt + 1'b1;
                    if (tick_cnt == 4'd15) begin

                        tick_cnt <= '0;
                        // sample bit center
                        shreg <= {uart_rx_in_sync, shreg[DATA_BITS-1:1]};  // shift in LSB-first

                        if (bit_idx == DATA_BITS - 1) begin
                            state <= STOP;
                        end
                        bit_idx <= bit_idx + 1'b1;
                    end
                end
            end

            STOP: begin
                if (i_tick_16x) begin
                    tick_cnt <= tick_cnt + 1'b1;
                    if (tick_cnt == 4'd15) begin
                        o_data <= shreg;
                        state <= IDLE;
                        // one clock cycle strobe signal to signify data is valid
                        o_strobe <= 1'b1;
                    end
                end
            end

        endcase

        if (i_rst) begin
            state    <= IDLE;
            tick_cnt <= '0;
            bit_idx  <= '0;
            shreg    <= '0;
            samp     <= 0;
            o_data   <= '0;
            o_strobe <= 1'b0;
        end
    end
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
endmodule
