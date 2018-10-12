`timescale 1ns / 1ps

module f_divider(
    input en,
    input clk,
    output reg clk_display = 0,
    output reg clk_second = 0,
    output reg clk_main = 0
    );
//    parameter SECOND_N  = 100;
    parameter SECOND_N  = 100_000_000;
//    parameter DISPLAY_N =   1;
    parameter DISPLAY_N =      50_000;
//    parameter MAIN_N    =   1;
    parameter MAIN_N    =   1_000_000;
    
    reg [26:0] second_counter = 0;
    reg [26:0] display_counter = 0;
    reg [26:0] main_counter = 0;
    
    always @ (posedge clk) begin
        if (second_counter == SECOND_N) begin
            second_counter = 0;
            clk_second = !clk_second;
        end else
            second_counter = second_counter + 1;
            
        if (display_counter == DISPLAY_N) begin
            display_counter = 0;
            clk_display = !clk_display;
        end else
            display_counter = display_counter + 1;

        if (main_counter == MAIN_N) begin
            main_counter = 0;
            clk_main = !clk_main;
        end else
            main_counter = main_counter + 1;

        if (!en) begin
            // clk_main = 0;
            clk_display = 0;
            // clk_second = 0;
        end
    end
    
endmodule
