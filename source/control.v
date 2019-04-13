module Control#(parameter screen_height = 480)
(
 input i_clk,
 input i_reset,
 input i_control1_left,
 input i_control1_right,
 input i_control2_left,
 input i_control2_right, 
 output [9:0] o_y_paddle1_pos,
 output [9:0] o_y_paddle2_pos
);

    wire slow_clk;
    clock_enable u1(i_clk, slow_clk);

    reg [9:0] control1;
    reg [9:0] control2;

    always @(posedge slow_clk)
    begin
        if (i_reset)
            control1 <= screen_height / 2;
        else
        if (i_control1_left)
            control1 <= control1 + 1;
        else
        if (i_control1_right && control1 > 0)
            control1 <= control1 - 1;
    end

    always @(posedge slow_clk)
    begin
        if (i_reset)
            control2 <= screen_height / 2;
        else
        if (i_control2_left)
            control2 <= control2 + 1;
        else
        if (i_control2_right && control2 > 0)
            control2 <= control2 - 1;
    end

    assign o_y_paddle1_pos = control1;
    assign o_y_paddle2_pos = control2;

endmodule
