module Paddle #(parameter paddle_margin = 30,
                parameter paddle_height = 50,
                parameter paddle_width = 10,
                parameter screen_width = 640,
                parameter screen_height = 480)
(
 input [9:0] i_pixel_x,
 input [9:0] i_pixel_y,
 input visible_area,
 input [9:0] i_y_paddle1_pos,
 input [9:0] i_y_paddle2_pos,

 output reg o_r,
 output reg o_g,
 output reg o_b
);

always @(i_pixel_x, i_pixel_y, visible_area, i_y_paddle1_pos, i_y_paddle2_pos)
begin
    if (visible_area)
    begin
        if ( i_pixel_x >= paddle_margin && i_pixel_x < (paddle_margin + paddle_width) 
          && i_pixel_y > i_y_paddle1_pos && i_pixel_y < (i_y_paddle1_pos + paddle_height))
        begin
            o_r <= 1;
            o_g <= 1;
            o_b <= 1;
        end
        else if ( i_pixel_x >= (screen_width - paddle_margin) && i_pixel_x < (screen_width - paddle_margin + paddle_width)
          && i_pixel_y > i_y_paddle2_pos && i_pixel_y < (i_y_paddle2_pos + paddle_height))
        begin
            o_r <= 1;
            o_g <= 1;
            o_b <= 1;
        end
        else
        begin
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