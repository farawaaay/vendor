`timescale 1ns / 1ps

module display(
    input en,
    input hello,
    input [3:0] int_ten,
    input [3:0] int_one,
    input float,

    input show_left,
    input [3:0] int_ten_left,
    input [3:0] int_one_left,
    input float_left,

    input clk_display,
    output reg [7:0] AN = 1,
    output reg [7:0] SEG = 8'b11111111
    );
    
    reg [3:0] scan_count = 0;
    always @ (posedge clk_display) begin
        if (scan_count == 7)
            scan_count = 0;
        else
            scan_count = scan_count + 1;
    end
    
    always @(scan_count) begin
        case ( scan_count )
            3'b000 : AN = ~8'b00000001;
            3'b001 : AN = ~8'b00000010;
            3'b010 : AN = ~8'b00000100;
            3'b011 : AN = ~8'b00001000;
            3'b100 : AN = ~8'b00010000;
            3'b101 : AN = ~8'b00100000;
            3'b110 : AN = ~8'b01000000;
            3'b111 : AN = ~8'b10000000;
            default: AN = ~8'b00000000;
        endcase
        if (!en)
            AN = ~8'b0000_0000;
    end

    always @(int_ten or int_one or scan_count or hello or float) begin
        if (hello) begin
            case ( scan_count )
                3'b000 : SEG=8'b11000000; // O
                3'b001 : SEG=8'b11000111; // L
                3'b010 : SEG=8'b11000111; // L
                3'b011 : SEG=8'b10000110; // E
                3'b100 : SEG=8'b10001001; // H
                default: SEG=8'b11111111;
            endcase
        end else begin
            if (scan_count == 0) begin
                SEG = 8'b11000000;
            end else if (scan_count == 1) begin
                if (float)
                    SEG = 8'b10010010; // 5
                else
                    SEG = 8'b11000000; // 0
            end else if (scan_count == 2) begin
                case (int_one)
                    0: SEG=8'b01000000;// 0.
                    1: SEG=8'b01111001;// 1.
                    2: SEG=8'b00100100;// 2.
                    3: SEG=8'b00110000;// 3.
                    4: SEG=8'b00011001;// 4.
                    5: SEG=8'b00010010;// 5.
                    6: SEG=8'b00000010;// 6.
                    7: SEG=8'b01111000;// 7.
                    8: SEG=8'b00000000;// 8.
                    9: SEG=8'b00010000;// 9.
                    default: SEG=8'b11111111;
                endcase
            end else if (scan_count == 3) begin
                case (int_ten)
                    // 0: SEG=8'b11000000;// 0
                    1: SEG=8'b11111001;// 1
                    2: SEG=8'b10100100;// 2
                    3: SEG=8'b10110000;// 3
                    4: SEG=8'b10011001;// 4
                    5: SEG=8'b10010010;// 5
                    6: SEG=8'b10000010;// 6
                    7: SEG=8'b11111000;// 7
                    8: SEG=8'b10000000;// 8
                    9: SEG=8'b10010000;// 9
                    default: SEG=8'b11111111;
                endcase
            end else if (show_left) begin
                if (scan_count == 4) begin
                    SEG = 8'b11000000;
                end else if (scan_count == 5) begin              
                    if (float_left)
                        SEG = 8'b10010010; // 5
                    else
                        SEG = 8'b11000000; // 0
                end else if (scan_count == 6) begin
                    case (int_one_left)
                        0: SEG=8'b01000000;// 0.
                        1: SEG=8'b01111001;// 1.
                        2: SEG=8'b00100100;// 2.
                        3: SEG=8'b00110000;// 3.
                        4: SEG=8'b00011001;// 4.
                        5: SEG=8'b00010010;// 5.
                        6: SEG=8'b00000010;// 6.
                        7: SEG=8'b01111000;// 7.
                        8: SEG=8'b00000000;// 8.
                        9: SEG=8'b00010000;// 9.
                        default: SEG=8'b11111111;
                    endcase
                end else if (scan_count == 7) begin
                    case (int_ten_left)
                        // 0: SEG=8'b11000000;// 0
                        1: SEG=8'b11111001;// 1
                        2: SEG=8'b10100100;// 2
                        3: SEG=8'b10110000;// 3
                        4: SEG=8'b10011001;// 4
                        5: SEG=8'b10010010;// 5
                        6: SEG=8'b10000010;// 6
                        7: SEG=8'b11111000;// 7
                        8: SEG=8'b10000000;// 8
                        9: SEG=8'b10010000;// 9
                        default: SEG=8'b11111111;
                    endcase
                end
            end else
                SEG=8'b11111111;
        end
        if (!en)
            SEG=8'b11111111;
    end
endmodule
