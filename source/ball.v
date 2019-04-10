module Ball #(parameter paddle_margin = 30,
              parameter paddle_width = 10,
              parameter paddle_height = 50,
              parameter screen_width = 640,
              parameter screen_height = 480)
(input [9:0] i_pixel_x,
 input [9:0] i_pixel_y,
 input visible_area,
 input [9:0] i_paddle1_y,
 input [9:0] i_paddle2_y,
 
 output reg o_r,
 output reg o_g,
 output reg o_b
);

`define BALL_X_SIZE   10'd8
`define BALL_Y_SIZE   10'd10
`define BALL_SPEED   10'd2

`define RIGHT       1'b0
`define LEFT        1'b1
`define DOWN        1'b0
`define UP          1'b1

reg [9:0] x_pos = screen_width / 2;
reg [9:0] y_pos = screen_height / 2; 

reg x_dir;
reg y_dir;

reg frame_index;

always @(i_pixel_x or i_pixel_y)
begin
    if (i_pixel_x == 0 && i_pixel_y == 0)
        frame_index = 1;
    else
        frame_index = 0;
end

// X Rebound logic
always @(posedge frame_index) begin
    if (x_dir == `RIGHT) begin
        if ((x_pos + `BALL_X_SIZE + `BALL_SPEED) >= screen_width || 
            (x_pos >= (screen_width - paddle_margin - `BALL_X_SIZE) && y_pos >= i_paddle2_y && y_pos < (i_paddle2_y + paddle_height + `BALL_Y_SIZE)) )
            x_dir <= `LEFT;
        else
            x_pos <= x_pos + `BALL_SPEED;
    end else begin
        if (x_pos < `BALL_SPEED ||
            (x_pos <= (paddle_margin + paddle_width) && y_pos >= i_paddle1_y && y_pos < (i_paddle1_y + paddle_height + `BALL_Y_SIZE)))
            x_dir <= `RIGHT;
        else
            x_pos <= x_pos - `BALL_SPEED;
    end
end

// Y Rebound logic
always @(posedge frame_index) begin
    if (y_dir == `DOWN) begin
        if ((y_pos + `BALL_Y_SIZE + `BALL_SPEED) >= screen_height)
            y_dir <= `UP;
        else
            y_pos <= y_pos + `BALL_SPEED;
    end else begin
        if (y_pos < `BALL_SPEED)
            y_dir <= `DOWN;
        else
            y_pos <= y_pos - `BALL_SPEED;
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