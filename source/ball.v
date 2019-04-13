module Ball #(parameter paddle_margin = 30,
              parameter paddle_width = 10,
              parameter paddle_height = 50,
              parameter screen_width = 640,
              parameter screen_height = 480)
(input i_clk,
 input [9:0] i_pixel_x,
 input [9:0] i_pixel_y,
 input visible_area,
 input [9:0] i_paddle1_y,
 input [9:0] i_paddle2_y,
 input i_reset,
 
 output reg o_r,
 output reg o_g,
 output reg o_b,
 output reg [3:0] o_score1,
 output reg [3:0] o_score2
);

`define BALL_X_SIZE   10'd8
`define BALL_Y_SIZE   10'd10
`define BALL_SPEED   10'd2

`define RIGHT       1'b0
`define LEFT        1'b1
`define DOWN        1'b0
`define UP          1'b1

reg [9:0] x_pos;
reg [9:0] y_pos;
reg [9:0] x_pos_next = screen_width / 2;
reg [9:0] y_pos_next = screen_height / 2;
reg [3:0] score1_next = 0;
reg [3:0] score2_next = 0;
reg [9:0] x_delta;
reg [9:0] x_delta_next = `BALL_SPEED;
reg [9:0] hit_position_y;

reg x_dir, x_dir_next = `RIGHT;
reg y_dir, y_dir_next = `UP;

assign frame_tick = (i_pixel_x == 0) && (i_pixel_y == 481);

always @(posedge i_clk, posedge i_reset)
begin
  if (i_reset)
     begin
        x_pos <= screen_width / 2;
        y_pos <= screen_height / 2; 
        o_score1 <= 0;
        o_score2 <= 0;
        x_dir <= `RIGHT;
        y_dir <= `UP;
        x_delta <=  `BALL_SPEED;
     end   
  else
     begin
        x_pos <= x_pos_next;
        y_pos <= y_pos_next;
        o_score1 <= score1_next;
        o_score2 <= score2_next;
        x_dir <= x_dir_next;
        x_dir <= x_dir_next;
        y_dir <= y_dir_next;
        x_delta <= x_delta_next;
     end
end


// X Rebound logic
always @*   
begin
    x_pos_next = x_pos;
    score1_next = o_score1;
    score2_next = o_score2;
    x_dir_next = x_dir;
    x_delta_next = x_delta;

    if ((x_pos + `BALL_X_SIZE + `BALL_SPEED) >= screen_width)
    begin
        x_pos_next = screen_width / 2;
        
        if (o_score1 < 4'd10)
        begin
            score1_next = o_score1 + 1;
        end

    end else if (x_pos < `BALL_SPEED)
    begin
        x_pos_next = screen_width / 2;

        if (o_score1 < 4'd10)
        begin
            score2_next = o_score2 + 1;
        end
    end else if (frame_tick)
        if (x_dir == `RIGHT) begin
            if (x_pos >= (screen_width - paddle_margin - `BALL_X_SIZE) && y_pos >= i_paddle2_y && y_pos < (i_paddle2_y + paddle_height + `BALL_Y_SIZE))
            begin
                x_dir_next = `LEFT;
                hit_position_y = y_pos - i_paddle2_y;

                if (hit_position_y < (paddle_height / 5) || hit_position_y > (4 * paddle_height / 5))
                    x_delta_next = 3 * `BALL_SPEED; // ball was received using an extremity of the paddle => speed up
                else
                    x_delta_next = `BALL_SPEED;
            end else
                x_pos_next = x_pos + x_delta;
        end else begin
            if (x_pos <= (paddle_margin + paddle_width) && y_pos >= i_paddle1_y && y_pos < (i_paddle1_y + paddle_height + `BALL_Y_SIZE))
            begin
                x_dir_next = `RIGHT;
                hit_position_y = y_pos - i_paddle2_y;

                if (hit_position_y < (paddle_height / 5) || hit_position_y > (4 * paddle_height / 5))
                    x_delta_next = 3 * `BALL_SPEED; // ball was received using an extremity of the paddle => speed up
                else
                    x_delta_next = `BALL_SPEED;
            end else
                x_pos_next = x_pos - x_delta;
    end
end

// Y Rebound logic
always @* begin
    y_pos_next = y_pos;
    y_dir_next = y_dir;

    if (frame_tick)
        if (y_dir == `DOWN) begin
            if ((y_pos + `BALL_Y_SIZE + `BALL_SPEED) >= screen_height)
                y_dir_next = `UP;
            else
                y_pos_next = y_pos + `BALL_SPEED;
        end else begin
            if (y_pos < `BALL_SPEED)
                y_dir_next = `DOWN;
            else
                y_pos_next = y_pos - `BALL_SPEED;
        end
end

// Display logic
always @(i_pixel_x, i_pixel_y, x_pos, y_pos, visible_area)
begin
    if (visible_area)
    begin

        if ( i_pixel_x >= x_pos && i_pixel_x < (`BALL_X_SIZE + x_pos) 
           && i_pixel_y >  y_pos && i_pixel_y < (`BALL_Y_SIZE + y_pos))
        begin
             // White
             o_r <= 1;
             o_g <= 1;
             o_b <= 1;
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