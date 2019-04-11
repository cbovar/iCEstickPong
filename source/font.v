module font(
            input [9:0] i_font_x,
            input [9:0] i_font_y,
            input [9:0] i_pixel_x,
            input [9:0] i_pixel_y,
            input visible_area,
            input [6:0] i_digit,

            output reg o_r,
            output reg o_g,
            output reg o_b
            );


`define DIGIT_SEGMENT_PARAM1  10'd20
`define DIGIT_SEGMENT_PARAM2  10'd4

// Display logic
always @(i_pixel_x, i_pixel_y, i_digit, visible_area, i_font_x, i_font_y)
begin
    if (visible_area)
    begin
        if (
            (i_digit[0] == 1 && i_pixel_x >= (i_font_x + `DIGIT_SEGMENT_PARAM2) && i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM1) && i_pixel_y >= i_font_y && i_pixel_y < ( i_font_y + `DIGIT_SEGMENT_PARAM2)) ||
            (i_digit[1] == 1 && i_pixel_x >= i_font_x && i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM2) && i_pixel_y >= (i_font_y + `DIGIT_SEGMENT_PARAM2) && i_pixel_y < ( i_font_y + `DIGIT_SEGMENT_PARAM1)) ||
            (i_digit[2] == 1 && i_pixel_x >= (i_font_x + `DIGIT_SEGMENT_PARAM1) &&  i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM1 + `DIGIT_SEGMENT_PARAM2) && i_pixel_y >= (i_font_y + `DIGIT_SEGMENT_PARAM2) && i_pixel_y < ( i_font_y + `DIGIT_SEGMENT_PARAM1)) ||
            (i_digit[3] == 1 && i_pixel_x >= (i_font_x + `DIGIT_SEGMENT_PARAM2) && i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM1) && i_pixel_y >= (i_font_y + `DIGIT_SEGMENT_PARAM1) && i_pixel_y < ( i_font_y + `DIGIT_SEGMENT_PARAM1 + `DIGIT_SEGMENT_PARAM2)) ||
            (i_digit[4] == 1 && i_pixel_x >= i_font_x && i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM2) && i_pixel_y >= (i_font_y + `DIGIT_SEGMENT_PARAM1 + `DIGIT_SEGMENT_PARAM2)  && i_pixel_y < ( i_font_y + 2 * `DIGIT_SEGMENT_PARAM1)) ||
            (i_digit[5] == 1 && i_pixel_x >= (i_font_x + `DIGIT_SEGMENT_PARAM1) &&  i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM1 + `DIGIT_SEGMENT_PARAM2) && i_pixel_y >= (i_font_y + `DIGIT_SEGMENT_PARAM1 + `DIGIT_SEGMENT_PARAM2)  && i_pixel_y < ( i_font_y + 2 * `DIGIT_SEGMENT_PARAM1)) ||
            (i_digit[6] == 1 && i_pixel_x >= (i_font_x + `DIGIT_SEGMENT_PARAM2) && i_pixel_x < (i_font_x + `DIGIT_SEGMENT_PARAM1) && i_pixel_y >= (i_font_y + 2 * `DIGIT_SEGMENT_PARAM1)  && i_pixel_y < ( i_font_y + 2 * `DIGIT_SEGMENT_PARAM1 + `DIGIT_SEGMENT_PARAM2))
        )
        begin
             // White
             o_r <= 1;
             o_g <= 0;
             o_b <= 0;
        end
        else
        begin
            // Black / nothing
            o_r <= 0;
            o_g <= 0;
            o_b <= 0;
        end
    end
    else
    begin
        o_r <= 0;
        o_g <= 0;
        o_b <= 0;
    end
end

endmodule