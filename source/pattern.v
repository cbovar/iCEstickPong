module Pattern #(parameter hbp = 144, 	// end of horizontal back porch
                 parameter hfp = 784, 	// beginning of horizontal front porch
                 parameter vbp = 31, 	// end of vertical back porch
                 parameter vfp = 511) 	// beginning of vertical front porch
(input [9:0] i_hc,
 input [9:0] i_vc,
 output reg o_r,
 output reg o_g,
 output reg o_b
);

always @(i_hc, i_vc)
begin
	// first check if we're within vertical active video range
	if (i_vc >= vbp && i_vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (i_hc >= hbp && i_hc < (hbp+80))
		begin
			o_r <= 1;
			o_g <= 1;
			o_b <= 1;
		end
		// display yellow bar
		else if (i_hc >= (hbp+80) && i_hc < (hbp+160))
		begin
			o_r <= 1;
			o_g <= 1;
			o_b <= 0;
		end
		// display cyan bar
		else if (i_hc >= (hbp+160) && i_hc < (hbp+240))
		begin
			o_r <= 1;
			o_g <= 0;
			o_b <= 1;
		end
		// display green bar
		else if (i_hc >= (hbp+240) && i_hc < (hbp+320))
		begin
			o_r <= 0;
			o_g <= 1;
			o_b <= 0;
		end
		// display magenta bar
		else if (i_hc >= (hbp+320) && i_hc < (hbp+400))
		begin
			o_r <= 0;
			o_g <= 1;
			o_b <= 1;
		end
		// display red bar
		else if (i_hc >= (hbp+400) && i_hc < (hbp+480))
		begin
			o_r <= 1;
			o_g <= 0;
			o_b <= 0;
		end
		// display blue bar
		else if (i_hc >= (hbp+480) && i_hc < (hbp+560))
		begin
			o_r <= 0;
			o_g <= 0;
			o_b <= 1;
		end
		// display black bar
		else if (i_hc >= (hbp+560) && i_hc < (hbp+640))
		begin
			o_r <= 0;
			o_g <= 0;
			o_b <= 0;
		end
		// we're outside active horizontal range so display black
		else
		begin
			o_r <= 0;
			o_g <= 0;
			o_b <= 0;
		end
	end

	// we're outside active vertical range so display black
	else
	begin
			o_r <= 0;
			o_g <= 0;
			o_b <= 0;
	end
end

endmodule