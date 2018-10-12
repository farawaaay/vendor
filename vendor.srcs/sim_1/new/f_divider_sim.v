`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/08 19:38:33
// Design Name: 
// Module Name: f_divider_sim
// Project Name: 
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


module f_divider_sim();
    wire second;
    wire display;
    wire main;
    reg clk = 0;
    always #10 clk=~clk;
    f_divider uut(1, clk, display, second, main);
endmodule
