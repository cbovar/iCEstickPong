module top(
  input i_pclk,		// pll clock: 25.13MHz

  // VGA
  output o_hsync,		// horizontal sync out
  output o_vsync,		// vertical sync out
  output o_r,
  output o_g,
  output o_b,
  output LED1,
  output LED2,
  output LED3,
  output LED4,
  output LED5,
  input i_pio_17, // reset paddle 1
  input i_pio_16, // right paddle 1
  input i_pio_15, // left paddle 1
  input i_pio_14, // right paddle 2
  input i_pio_13  // left paddle 2
	);

  localparam hbp = 10'd144;
  localparam hfp = 10'd784;
  localparam vbp = 10'd31;
  localparam vfp = 10'd511;
  
  localparam SCREEN_WIDTH = 10'd640;
  localparam SCREEN_HEIGHT = 10'd480;

  localparam PADDLE_MARGIN = 10'd30;
  localparam PADDLE_HEIGHT = 10'd100;
  localparam PADDLE_WIDTH = 10'd10;
  
  wire clk;

  // PLL
  SB_PLL40_CORE #(.FEEDBACK_PATH("SIMPLE"),
                  .PLLOUT_SELECT("GENCLK"),
                  .DIVR(4'b0001),
                  .DIVF(7'b1000010),
                  .DIVQ(3'b100),
                  .FILTER_RANGE(3'b001)
                 ) uut (
                         .REFERENCECLK(i_pclk),
                         .PLLOUTCORE(clk),
                         .LOCK(D5),
                         .RESETB(1'b1),
                         .BYPASS(1'b0)
                        );

  // VGA Sync
  wire w_hsync, w_vsync, w_visible_area;
  wire [9:0] w_pixel_x, w_pixel_y;
  
  VGA_Sync vga_inst(.i_clk(clk),
                    .o_hsync(w_hsync),
                    .o_vsync(w_vsync),
                    .o_pixel_x(w_pixel_x),
                    .o_pixel_y(w_pixel_y),
                    .o_visible_area(w_visible_area)
                   );

  assign o_hsync = w_hsync;
  assign o_vsync = w_vsync;
 
  // Draw pattern

//  wire w_r1, w_g1, w_b1;  
//  Pattern pattern_inst(.i_hc(w_hc),
//                       .i_vc(w_vc),
//                       .o_r(w_r1),
//                       .o_g(w_g1),
//                       .o_b(w_b1)
//                      );

// Controls
 wire w_left1, w_right1, w_reset, w_left2, w_right2;

 debounce debounce_inst1(.i_input(i_pio_17), .i_clk(clk), .o_output(w_reset));
 debounce debounce_inst2(.i_input(i_pio_16), .i_clk(clk), .o_output(w_right1));
 debounce debounce_inst3(.i_input(i_pio_15), .i_clk(clk), .o_output(w_left1));
 debounce debounce_inst4(.i_input(i_pio_14), .i_clk(clk), .o_output(w_right2));
 debounce debounce_inst5(.i_input(i_pio_13), .i_clk(clk), .o_output(w_left2));

//  assign LED1 = ~w_right1;
//  assign LED2 = ~w_left2;
//  assign LED3 = ~w_left1;
//  assign LED4 = ~w_right2;
//  assign LED5 = ~w_reset;

 wire [9:0] w_control1, w_control2;

 Control control_inst(
                .i_clk(clk),
                .i_reset(~w_reset),
                .i_control1_left(~w_left1),
                .i_control1_right(~w_right1),
                .i_control2_left(~w_left2),
                .i_control2_right(~w_right2),
                .o_y_paddle1_pos(w_control1),
                .o_y_paddle2_pos(w_control2)
               );

 // Ball
 wire w_r2, w_g2, w_b2;
 wire [3:0] w_score1, w_score2; 
 Ball   #(
          .paddle_margin(PADDLE_MARGIN),
          .paddle_width(PADDLE_WIDTH),
          .paddle_height(PADDLE_HEIGHT),
          .screen_width(SCREEN_WIDTH),
          .screen_height(SCREEN_HEIGHT)
          ) ball_inst(
                .i_pixel_x(w_pixel_x),
                .i_pixel_y(w_pixel_y),
                .visible_area(w_visible_area),
                .i_paddle1_y(w_control1),
                .i_paddle2_y(w_control2),
                .o_r(w_r2),
                .o_g(w_g2),
                .o_b(w_b2),
                .o_score1(w_score1),
                .o_score2(w_score2)
               );

// Paddle
 wire w_r3, w_g3, w_b3;
 Paddle #(
          .paddle_margin(PADDLE_MARGIN),
          .paddle_width(PADDLE_WIDTH),
          .paddle_height(PADDLE_HEIGHT),
          .screen_width(SCREEN_WIDTH),
          .screen_height(SCREEN_HEIGHT)
          ) paddle_inst(
                .i_pixel_x(w_pixel_x),
                .i_pixel_y(w_pixel_y),
                .visible_area(w_visible_area),
                .i_y_paddle1_pos(w_control1),
                .i_y_paddle2_pos(w_control2),
                .o_r(w_r3),
                .o_g(w_g3),
                .o_b(w_b3)
               );

// Text
wire [6:0] w_data1;
font_rom font_rom_inst1(
                       .i_clk(clk),
                       .i_addr(w_score1),
                       .o_data(w_data1)
                      );

localparam FONT1_X = 10'd160;
localparam FONT_Y = 10'd40;
localparam FONT2_X = 10'd480;

wire w_r4, w_g4, w_b4;
font font_inst1(
              .i_font_x(FONT1_X),
              .i_font_y(FONT_Y),
              .i_pixel_x(w_pixel_x),
              .i_pixel_y(w_pixel_y),
              .visible_area(w_visible_area),
              .i_digit(w_data1),
              .o_r(w_r4),
              .o_g(w_g4),
              .o_b(w_b4)
             );

wire [6:0] w_data2;
font_rom font_rom_inst2(
                       .i_clk(clk),
                       .i_addr(w_score2),
                       .o_data(w_data2)
                      );

wire w_r5, w_g5, w_b5;
font font_inst2(
              .i_font_x(FONT2_X),
              .i_font_y(FONT_Y),
              .i_pixel_x(w_pixel_x),
              .i_pixel_y(w_pixel_y),
              .visible_area(w_visible_area),
              .i_digit(w_data2),
              .o_r(w_r5),
              .o_g(w_g5),
              .o_b(w_b5)
             );


 assign o_r =  w_r2| w_r3| w_r4| w_r5;
 assign o_g =  w_g2| w_g3| w_g4| w_g5;
 assign o_b =  w_b2| w_b3| w_b4| w_b5;

assign LED1 = 0;
assign LED2 = 0;
assign LED3 = 0;
assign LED4 = 0;
assign LED5 = 0;


endmodule