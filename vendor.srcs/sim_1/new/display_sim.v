module display_sim();
    wire [7:0]AN;
    wire [7:0]SEG;
    reg clk = 0;
    always #10 clk=~clk;
    display d(1, 9, 9, 1, clk, AN, SEG);
endmodule