`timescale 1ns / 1ps

module top_module(
    input  power,
    input  coin_type,
    input  insert_coin,
    input  drink_1,
    input  drink_2,
    input  cancel,
    
    input  clk,
    
    output reg power_led,
    output error,
    output take_drink,
    output take_money,
    output in_use,
    output reg drink_2_green, // can buy drink 2
    output reg drink_2_red, // cannot buy drink 2
    output reg drink_1_green, // can buy drink 1
    output reg drink_1_red,  // cannot buy drink 1
    
    output [7:0] AN,
    output [7:0] SEG
    );
    wire second_clk;
    wire display_clk;
    wire main_clk;

    wire hello;
    wire [3:0]money_ten;
    wire [3:0]money_one;
    wire money_float;

    wire show_left;
    wire [3:0]money_ten_back;
    wire [3:0]money_one_back;
    wire money_float_back;

    wire drink_2_a;
    wire drink_1_a;
    
    wire enable;

    // instance of FSM module
    fsm fsm(
        power,
        main_clk,
        second_clk,

        coin_type,
        insert_coin,
        drink_1,
        drink_2,
        cancel,

        enable,
        take_drink,
        take_money,
        in_use,
        error,
        drink_2_a,
        drink_1_a,

        hello,
        money_ten,
        money_one,
        money_float,

        show_left,
        money_ten_back,
        money_one_back,
        money_float_back
    );
    // instance of frequency divider
    f_divider f_d(
        enable,
        clk,
        display_clk,
        second_clk,
        main_clk
    );
    // instance of display module
    display d(
        enable,
        hello,
        money_ten,
        money_one,
        money_float,

        show_left,
        money_ten_back,
        money_one_back,
        money_float_back,
        
        display_clk,
        AN,
        SEG
    );
    
    // update RGB led when user can buy drink 1
    always @(drink_1_a) begin
        drink_1_green = drink_1_a;
        drink_1_red = ~drink_1_a;

        if (!enable) begin
            drink_1_green = 0;
            drink_1_red = 0;
        end
    end

    // update RGB led when user can buy drink 2
    always @(drink_2_a) begin
        drink_2_green = drink_2_a;
        drink_2_red = ~drink_2_a;

        if (!enable) begin
            drink_2_green = 0;
            drink_2_red = 0;
        end
    end
    
    always @(enable)
        power_led = enable;
endmodule
