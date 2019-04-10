module VGA_Sync #(parameter hpixels = 800, // horizontal pixels per line
                  parameter vlines = 521,  // vertical lines per frame
                  parameter hpulse = 96,   // hsync pulse length
                  parameter vpulse = 2,   // vsync pulse length
                  parameter hbp = 144,
                  parameter hfp = 784,
                  parameter vbp = 31,
                  parameter vfp = 511)
   (input i_clk,
    output o_hsync,
    output o_vsync,
    output reg [9:0] o_pixel_x = 0, // registers for storing horizontal counter
    output reg [9:0] o_pixel_y = 0, // registers for storing vertical counter
    output reg o_visible_area
   );

// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

reg [9:0] o_hc = 0;
reg [9:0] o_vc = 0;

always @(posedge i_clk)
begin
    // keep counting until the end of the line
    if (o_hc < hpixels - 1)
        o_hc <= o_hc + 1;
    else
    // When we hit the end of the line, reset the horizontal
    // counter and increment the vertical counter.
    // If vertical counter is at the end of the frame, then
    // reset that one too.
    begin
        o_hc <= 0;
        if (o_vc < vlines - 1)
            o_vc <= o_vc + 1;
        else
            o_vc <= 0;
    end
end

always @(o_hc, o_vc)
begin
    if (o_vc >= vbp && o_vc < vfp && o_hc >= hbp && o_hc < hfp)
    begin
        o_visible_area <= 1;
    end
    else
    begin
        o_visible_area <= 0;
    end
end

always @(o_hc)
begin
	o_pixel_x <= o_hc - hbp;
end

always @(o_vc)
begin
	o_pixel_y <= o_vc - vbp;
end


assign o_hsync = (o_hc < hpulse) ? 0:1;
assign o_vsync = (o_vc < vpulse) ? 0:1;

endmodule