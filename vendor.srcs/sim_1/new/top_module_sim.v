`timescale 1ns / 1ps
module top_module_sim();
    reg clk = 0;
    reg coin_type = 0;
    reg insert_coin = 0;
    reg power = 0;
    reg drink_1 = 0;
    reg drink_2 = 0;
    reg cancel = 0;
    
    initial begin
        
        #100 power = 1;
        #100 power = 0; // push power button.
        
        #2000; // wait, for checking HELLO
        
        #100 insert_coin = 1;
        #100 insert_coin = 0; // push insert_coin button
        
        #100 drink_1 = 1;
        #100 drink_1 = 0; // buy drink_1
        
        #100 drink_2 = 1;
        #100 drink_2 = 0; // by drink_2
        
        #2000;
        
        coin_type = 1; // change the coin_type to "10 yuan"
        
        #100 insert_coin = 1;
        #100 insert_coin = 0; // push insert_coin button
                
        #100 drink_1 = 1;
        #100 drink_1 = 0; // buy drink_1
                
        #100 drink_2 = 1;
        #100 drink_2 = 0; // by drink_2
    end
    
    always #2 clk=~clk;
    
    wire power_led;
    wire error_led;
    wire take_drink_led;
    wire take_money_led;
    wire in_use_led;
    wire drink_2_green;
    wire drink_2_red;
    wire drink_1_green;
    wire drink_1_red;
    
    wire [7:0]AN;
    wire [7:0]SEG;
    
    top_module t_m(
        power,
        coin_type,
        insert_coin,
        drink_1,
        drink_2,
        cancel,
        
        clk,
        
        power_led,
        error_led,
        take_drink_led,
        take_money_led,
        in_use_led,
        drink_2_green, // drink 2
        drink_2_red, // drink 2
        drink_1_green, // drink 1
        drink_1_red,  // drink 1
        
        AN,
        SEG
    );
endmodule
