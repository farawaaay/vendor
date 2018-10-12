`timescale 1ns / 1ps

module fsm_sim();
    reg pwr = 0;         // power btn
    reg clk = 0;         // system clk
    reg second = 0;      // second clk
    reg coin_type = 0;   // coin_type switch
    reg insert_coin = 0; // insert_coin btn
    reg drink_1 = 0;     // drink_1 btn
    reg drink_2 = 0;     // drink_2 btn
    reg cancel = 0;      // cancel btn
    wire enable;     // enable all other module: f_divider, display
    wire take_drink; // drink is ok to take
    wire take_money; // money is ok to take
    wire in_use;     // this machine is in use
    wire error;      // operation is ERROR
    wire drink_2_a;  // can buy drink 2
    wire drink_1_a;  // can buy drink 1
    wire hello;      // display in hello mode
    wire [3:0]money_ten;
    wire [3:0]money_one;
    wire money_float;
    wire show_left;
    wire [3:0]money_ten_back;
    wire [3:0]money_one_back;
    wire money_float_back;

    initial begin
        #100 pwr = 1;
        #10 pwr = 0;      // push power button.
        
        #200;
        
        #100 insert_coin = 1;
        #10 insert_coin = 0; // push insert_coin button, 1 yuan now
        #100 insert_coin = 1;
        #10 insert_coin = 0; // push insert_coin button, 2 yuan now
        #100 insert_coin = 1;
        #10 insert_coin = 0; // push insert_coin button, 3 yuan now
        
        #100 drink_1 = 1;
        #10 drink_1 = 0;     // buy drink_1, 0.5 yuan now
        
        coin_type = 1;        // change the coin_type to "10 yuan"

        #100 insert_coin = 1;
        #10 insert_coin = 0; // 10.5 yuan now

        #100 drink_2 = 1;
        #10 drink_2 = 0;     // by drink_2, 5.5 yuan now
        
        #300;
        
        #100 cancel = 1;
        #10 cancel = 0; // push cancel button
        
        #300;
        #100 insert_coin = 1;
        #10 insert_coin = 0; // 10 yuan now
        
        #100 pwr = 1;
        #10 pwr = 0;
    end
    always #1 clk = ~clk;

    fsm fsm(
        pwr,         // power btn
        clk,         // system clk
        second,      // second clk
        coin_type,   // coin_type switch
        insert_coin, // insert_coin btn
        drink_1,     // drink_1 btn
        drink_2,     // drink_2 btn
        cancel,      // cancel btn
        enable,      // enable all other module: f_divider, display
        take_drink,  // drink is ok to take
        take_money,  // money is ok to take
        in_use,      // this machine is in use
        error,       // operation is ERROR
        drink_2_a,   // can buy drink 2
        drink_1_a,   // can buy drink 1
        hello,       // display in hello mode
        money_ten,
        money_one,
        money_float,
        show_left,
        money_ten_back,
        money_one_back,
        money_float_back
    );
endmodule
