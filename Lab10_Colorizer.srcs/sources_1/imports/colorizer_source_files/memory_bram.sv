`timescale 1ns/1ps

module memory_bram #(
    parameter int    WIDTH     = 128,
    parameter int    HEIGHT    = 128,
    parameter string INIT_FILE = "image.mem"  // hex bytes, one per line or space-separated
) (
    input  logic                            i_clk,
    input  logic                            i_rst,
    
    input  logic [$clog2(WIDTH*HEIGHT)-1:0] i_addr,
    output logic [                     7:0] o_data
);
    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    /*========================= DO NOT EDIT BEGINS ===============================*/
    localparam int DEPTH = WIDTH * HEIGHT;

    (* ram_style = "block" *) logic [7:0] mem[DEPTH];

    initial $readmemh(INIT_FILE, mem);

    // Synchronous read
    always_ff @(posedge i_clk) begin
        o_data <= mem[i_addr];

        if (i_rst) begin
            o_data <= '0;
        end
    end
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
    /*========================= DO NOT EDIT ENDS ===============================*/
endmodule
