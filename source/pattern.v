module Pattern(input i_clk,
	             input [9:0] i_pixel_x,
               input [9:0] i_pixel_y,
               input i_visible_area,
               output reg o_r,
               output reg o_g,
               output reg o_b
);

reg [9:0] pixel_offseted_x;
reg [9:0] pixel_offseted_y;
reg [9:0] pixel_offseted_x_next;
reg [9:0] pixel_offseted_y_next;
reg [6:0] offset;
reg [6:0] offset_next;
reg [1:0] counter_next;
reg [1:0] counter;

always @(posedge i_clk)
begin
  // pixel_offseted_x <= pixel_offseted_x_next;
  // pixel_offseted_y <= pixel_offseted_y_next;
  offset <= offset_next;
  counter <= counter_next;
end

assign frame_tick = (i_pixel_x == 0) && (i_pixel_y == 481);

always @*
begin
  // pixel_offseted_x_next = i_pixel_x + offset;
  // pixel_offseted_y_next = i_pixel_y + offset;

  offset_next = (frame_tick && counter_next == 0 ) ? offset + 1 : offset;
  counter_next = frame_tick ? counter + 1 : counter;
end

// assign pixel_offseted_x_next = i_pixel_x + offset;
// assign pixel_offseted_y_next = i_pixel_y + offset;

always @(i_pixel_x, i_pixel_y, i_visible_area, pixel_offseted_x, pixel_offseted_y)
begin
//   if ((i_pixel_x == 0) && (i_pixel_y == 481))
//     offset <= offset + 1;

  pixel_offseted_x <= i_pixel_x + offset;
  pixel_offseted_y <= i_pixel_y + offset;

//  if (i_visible_area && (i_pixel_x[9:5] + i_pixel_y[9:5]) % 2 == 0 && (i_pixel_x+ i_pixel_y) % 2 == 0)
  if (i_visible_area && (pixel_offseted_x[9:5] + pixel_offseted_y[9:5]) % 2 == 0 && (i_pixel_x + i_pixel_y) % 2 == 0)  
  begin
       o_r <= 0;
       o_g <= 0;
       o_b <= 1;
  end
  else
  begin
      o_r <= 0;
      o_g <= 0;
      o_b <= 0;
  end
end

endmodule