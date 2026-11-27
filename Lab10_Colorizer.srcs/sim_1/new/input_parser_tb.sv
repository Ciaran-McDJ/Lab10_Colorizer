`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Axel Greavette
// 
// Create Date: 11/26/2026 12:15:00 PM
// Design Name:  Input Parser Testbench
// Module Name: input_parser_tb
// Project Name: Lab 10 - Colorizer
// Target Devices: 
// Tool Versions: 
// Description: Testbench for the input parser module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module input_parser_tb();
    localparam int unsigned CLOCK_PERIOD = 10;

    logic       clk;
    logic       rst;
    logic [7:0] r_data;
    logic       r_strobe;
    logic       converter_start;
    logic [6:0] rgb_weights [3];

    always #(CLOCK_PERIOD/2) clk = ~clk;

    input_parser_top dut (
        .i_clk             (clk),
        .i_rst             (rst),
        .i_r_data          (r_data),
        .i_r_strobe        (r_strobe),
        .o_converter_start (converter_start),
        .o_rgb_weights     (rgb_weights)
    );

    task automatic send_byte(input logic [7:0] data);
        @(posedge clk);
        r_data   <= data;
        r_strobe <= 1'b1;
        @(posedge clk);
        r_strobe <= 1'b0;
        repeat (2) @(posedge clk);
    endtask

    task automatic send_cmd(input string cmd);
        for (int i = 0; i < cmd.len(); i++) begin
            send_byte(cmd[i]);
        end
        send_byte(8'h0D);
    endtask

    task automatic send_start();
        send_byte("s");
        @(posedge clk);
        r_data   <= 8'h0D;
        r_strobe <= 1'b1;
        @(posedge clk);
        r_strobe <= 1'b0;
    endtask

    initial begin
        clk      = 1'b0;
        rst      = 1'b1;
        r_data   = 8'h00;
        r_strobe = 1'b0;

        repeat (5) @(posedge clk);
        rst <= 1'b0;
        repeat (2) @(posedge clk);
        #1;

        // Default weights after reset
        assert (rgb_weights[0] === 6'd0 && rgb_weights[1] === 6'd16 && rgb_weights[2] === 6'd0)
            else $error("Default weights expected 0,16,0 got %0d,%0d,%0d",
                        rgb_weights[0], rgb_weights[1], rgb_weights[2]);

        // Set r31, g01, b05 then start
        send_cmd("r31");
        send_cmd("g01");
        send_cmd("b05");
        send_start();
        #1;

        assert (converter_start === 1'b1)
            else $error("converter_start did not assert on s<CR>");

        assert (rgb_weights[0] === 6'd31 && rgb_weights[1] === 6'd1 && rgb_weights[2] === 6'd5)
            else $error("First start expected 31,1,5 got %0d,%0d,%0d",
                        rgb_weights[0], rgb_weights[1], rgb_weights[2]);

        @(posedge clk);
        #1;
        assert (converter_start === 1'b0)
            else $error("converter_start stayed high for more than 1 cycle");

        // Update only green to 07, red and blue should persist
        send_cmd("g07");
        send_cmd("s");
        assert (rgb_weights[0] === 6'd31 && rgb_weights[1] === 6'd7 && rgb_weights[2] === 6'd5)
            else $error("Second start expected 31,7,5 got %0d,%0d,%0d",
                        rgb_weights[0], rgb_weights[1], rgb_weights[2]);

        // Trailing invalid characters after valid command should still save g01
        send_cmd("g01ashdhadsh");
        send_cmd("s");
        assert (rgb_weights[1] === 6'd1)
            else $error("Trailing chars expected G=1, got %0d", rgb_weights[1]);

        // Invalid characters in the middle should be rejected
        send_cmd("gsajdjajsd05");
        send_cmd("s");
        if (rgb_weights[1] !== 6'd1)
            $display("FAIL: middle invalid chars should be rejected, got G=%0d", rgb_weights[1]);
        else
            $display("PASS: middle invalid chars rejected");

        // Invalid characters before command should be rejected
        send_cmd("xyzg12");
        send_cmd("s");
        if (rgb_weights[1] !== 6'd1)
            $display("FAIL: leading invalid chars should be rejected, got G=%0d", rgb_weights[1]);
        else
            $display("PASS: leading invalid chars rejected");

        // Out of range weights should be rejected
        send_cmd("r40");
        send_cmd("g70");
        send_cmd("s");
        assert (rgb_weights[1] === 6'd1)
            else $error("g70 should be rejected, got G=%0d", rgb_weights[1]);

        send_cmd("r31");
        send_cmd("g0s");
        send_cmd("b32");
        send_cmd("");
        send_cmd("ottawa");
        send_cmd("s");
        assert(rgb_weights[0] === 6'd31 && rgb_weights[1] === 6'd70 && rgb_weights[2] === 6'd32)
            else $error("r31,g0s,b32 should be rejected, got %0d,%0d,%0d",
                        rgb_weights[0], rgb_weights[1], rgb_weights[2]);
        #50;
        $finish;
    end

endmodule
