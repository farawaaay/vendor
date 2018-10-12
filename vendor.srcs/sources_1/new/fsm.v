`timescale 1ns / 1ps

module fsm(
    input pwr,         // power btn
    input clk,         // system clk
    input second,      // second clk
    input coin_type,   // coin_type switch
    input insert_coin, // insert_coin btn
    input drink_1,     // drink_1 btn
    input drink_2,     // drink_2 btn
    input cancel,      // cancel btn
        
    output reg enable = 1,     // enable all other module: f_divider, display
    output reg take_drink = 0, // drink is ok to take
    output reg take_money = 0, // money is ok to take
    output reg in_use = 0,     // this machine is in use
    output reg error = 0,      // operation is ERROR
    output reg drink_2_a = 0,  // can buy drink 2
    output reg drink_1_a = 0,  // can buy drink 1

    output reg hello = 1,      // display in hello mode
    output reg [3:0]money_ten = 0,
    output reg [3:0]money_one = 0,
    output reg money_float = 0,

    output reg show_left = 0,
    output reg [3:0]money_ten_back = 0,
    output reg [3:0]money_one_back = 0,
    output reg money_float_back = 0
);
    reg [2:0]state = 4; // initial STATE is power_off status
    reg [7:0]time_to_show_money = 200;
    reg [7:0]time_to_show_drink = 200;
    reg [3:0]time_to_show_error = 15;
    reg power_on = 0;   // power is off defaultly

    // this reg is used for button debouncing.
    reg [3:0]throttle_reg = 12;

    // Main part of state machine, this FSM maintains 5 vars
    always @(state) begin
        case (state)
            0: begin
                hello = 1;
                enable = 1;
                show_left = 0;
                take_drink = 0;
                take_money = 0;
            end

            1: begin
                hello = 0;
                enable = 1;
                show_left = 0;
                take_drink = 0;
                take_money = 0;
            end
            
            2: begin
                hello = 0;
                enable = 1;                
                take_drink = 1;
                show_left = 0;
                take_money = 0;
            end

            3: begin
                hello = 0;
                enable = 1;
                show_left = 1;
                take_money = 1;
                take_drink = 0;
            end

            4: begin
                enable = 0;
                hello = 0;
                show_left = 0;
                take_money = 0;
                take_drink = 0;
            end
        endcase
    end

    always @(posedge clk) begin
        time_to_show_error = time_to_show_error - 1;
        if (time_to_show_error == 0) begin
            error = 0;
            time_to_show_error = 15;
        end
        // timer for take_money LED
        if (state == 3) begin
            time_to_show_money = time_to_show_money - 1;
            if (time_to_show_money == 0) begin
                if (money_ten != 0 || money_one != 0 || money_float != 0)
                    state = 1;
                else begin
                    if (power_on) 
                        state = 0;
                    else
                        state = 4;
                end
                time_to_show_money = 200;
            end
        end

        // timer for take_drink LED
        if (state == 2) begin
            time_to_show_drink = time_to_show_drink - 1;
            if (time_to_show_drink == 0) begin
                if (money_ten != 0 || money_one != 0 || money_float != 0)
                    state = 1;
                else
                    state = 0;
                time_to_show_drink = 200;
            end
        end


        if (insert_coin && power_on && throttle_reg == 0) begin
            if (state != 3 && state != 2) 
                state = 1;
            if (money_ten == 9 && money_one == 9) begin
                // retrun;
            end else begin
                if (coin_type == 0) begin
                    if (money_one == 9) begin
                        money_one = 0;
                        money_ten = money_ten + 1;
                    end else begin
                        money_one = money_one + 1;
                    end
                end else begin
                    if (money_ten != 9)  
                        money_ten = money_ten + 1;
                end
            end
            throttle_reg = 12;
        end else if (cancel && power_on && throttle_reg == 0) begin
            if (state == 1) begin
                state = 3;
                money_ten_back   = money_ten;
                money_one_back   = money_one;
                money_float_back = money_float;
                money_ten = 0;
                money_one = 0;
                money_float = 0;
            end
            throttle_reg = 12;
        end else if (drink_1 && power_on && throttle_reg == 0) begin
            // update money after buying
            if (money_one >= 3) begin
                if (money_float) begin
                    money_float = 0;
                    money_one = money_one - 2;
                end else begin
                    money_float = 1;
                    money_one = money_one - 3;
                end
                state = 2;
            end else if (money_one == 2 && money_float == 1) begin
                money_one = 0;
                money_float = 0;
                state = 2;
            end else if (money_ten >= 1) begin
                money_ten = money_ten - 1;
                if (money_float) begin
                    money_one = money_one + 10 - 2;
                    money_float = 0;
                end else begin
                    money_one = money_one + 10 - 3;
                    money_float = 1;
                end
                state = 2;
            end else
                error = 1;
            throttle_reg = 12;
        end else if (drink_2 && power_on && throttle_reg == 0) begin
            // update money after buying
            if (money_one >= 5) begin
                money_one = money_one - 5;
                state = 2;
            end else if (money_ten >= 1) begin
                money_ten = money_ten - 1;
                money_one = money_one + 10 - 5;
                state = 2;
            end else
                error = 1;
            throttle_reg = 12;
        end else if (pwr && throttle_reg == 0) begin
            power_on = ~power_on;
            if (power_on) begin
                if (state == 4)
                    state = 0;
            end else begin
                if (money_ten != 0 || money_one != 0 || money_float != 0) begin
                    state = 3;
                    money_ten_back   = money_ten;
                    money_one_back   = money_one;
                    money_float_back = money_float;
                    money_ten = 0;
                    money_one = 0;
                    money_float = 0;
                end else begin
                    state = 4;
                    money_ten = 0;
                    money_one = 0;
                    money_float = 0;
                end
            end

            throttle_reg = 12;
        end
        if (throttle_reg > 0) begin
            throttle_reg = throttle_reg - 1;
        end
    end

    // update drink_2_a and drink_1_a when money amount changes.
    always @(money_ten or money_one or money_float) begin
        if (money_ten != 0 || money_one != 0 || money_float != 0)
            if (money_ten > 0 || money_one >= 5) begin
                drink_2_a = 1;
                drink_1_a = 1;
            end else if (money_one >= 3 || (money_one == 2 && money_float == 1)) begin
                drink_1_a = 1;
                drink_2_a = 0;
            end else begin
                drink_2_a = 0;
                drink_1_a = 0;
            end
        else begin
            drink_2_a = 0;
            drink_1_a = 0;
        end
    end

    always @(hello) begin
        in_use = ~hello;
        if (!enable)
            in_use = 0;
    end
endmodule
