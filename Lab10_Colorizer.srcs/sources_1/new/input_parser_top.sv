`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Axel Greavette
// 
// Create Date: 11/25/2026 12:46:33 PM
// Design Name: Input Parser
// Module Name: input_parser_top
// Project Name: Lab 10 - Colorizer
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

    // ascii values so i dont have to keep checking the ascii table
    localparam logic [7:0] ASCII_S  = 8'h73;
    localparam logic [7:0] ASCII_R  = 8'h72;
    localparam logic [7:0] ASCII_G  = 8'h67;
    localparam logic [7:0] ASCII_B  = 8'h62;
    localparam logic [7:0] ASCII_CR = 8'h0D; // enter key
    localparam logic [7:0] ASCII_0  = 8'h30;
    localparam logic [7:0] ASCII_9  = 8'h39;

    // fsm states, hopefully this covers everything
    typedef enum logic [2:0] {
        IDLE,
        WAIT_START_CR,
        DIGIT_TENS,
        DIGIT_ONES,
        WAIT_WEIGHT_CR,
        INVALID
    } state_t;

    state_t state;
    logic [1:0] channel; // 0 = r, 1 = g, 2 = b
    logic [3:0] tens;
    logic [5:0] weight_val;
    logic [5:0] saved_weights [3]; // holds last valid weights until s is sent

    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            state             <= IDLE;
            channel           <= 2'd0;
            tens              <= 4'd0;
            weight_val        <= 6'd0;
            o_converter_start <= 1'b0;
            // default to 16 so it starts as grayscale
            saved_weights[0]  <= 6'd16;
            saved_weights[1]  <= 6'd16;
            saved_weights[2]  <= 6'd16;
            o_rgb_weights[0]  <= 6'd16;
            o_rgb_weights[1]  <= 6'd16;
            o_rgb_weights[2]  <= 6'd16;
        end else if (i_r_strobe) begin
            o_converter_start <= 1'b0;

            case (state)
                IDLE: begin
                    case (i_r_data)
                        ASCII_S:  state <= WAIT_START_CR;
                        ASCII_R: begin
                            channel <= 2'd0;
                            state   <= DIGIT_TENS;
                        end
                        ASCII_G: begin
                            channel <= 2'd1;
                            state   <= DIGIT_TENS;
                        end
                        ASCII_B: begin
                            channel <= 2'd2;
                            state   <= DIGIT_TENS;
                        end
                        ASCII_CR: state <= IDLE;
                        default:  state <= INVALID; // junk at the start, reject the whole line. dont fuck with me lil bro
                    endcase
                end

                WAIT_START_CR: begin
                    // push the saved weights out and start when enter is hit
                    if (i_r_data == ASCII_CR) begin
                        o_rgb_weights[0]  <= saved_weights[0];
                        o_rgb_weights[1]  <= saved_weights[1];
                        o_rgb_weights[2]  <= saved_weights[2];
                        o_converter_start <= 1'b1;
                        state             <= IDLE;
                    end
                end

                DIGIT_TENS: begin
                    if (i_r_data >= ASCII_0 && i_r_data <= ASCII_9) begin
                        tens  <= i_r_data - ASCII_0; // subtract 0x30 to get actual number
                        state <= DIGIT_ONES;
                    end else if (i_r_data == ASCII_CR) begin
                        state <= IDLE;
                    end else begin
                        state <= INVALID;
                    end
                end

                DIGIT_ONES: begin
                    if (i_r_data >= ASCII_0 && i_r_data <= ASCII_9) begin
                        // combine the two digits into one number
                        weight_val <= (tens * 4'd10) + (i_r_data - ASCII_0);
                        state      <= WAIT_WEIGHT_CR;
                    end else if (i_r_data == ASCII_CR) begin
                        state <= IDLE;
                    end else begin
                        state <= INVALID;
                    end
                end

                WAIT_WEIGHT_CR: begin
                    // already got a valid command so just ignore anything else until enter
                    if (i_r_data == ASCII_CR) begin
                        if (weight_val < 6'd31) begin
                            saved_weights[channel] <= weight_val;
                        end
                        state <= IDLE;
                    end
                end

                INVALID: begin
                    // someone typed dogshit, wait for enter to reset
                    if (i_r_data == ASCII_CR) begin
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
