module debounce(input i_input, input i_clk, output o_output);
	wire slow_clk;
	wire Q1, Q2;
	clock_enable u1(i_clk, slow_clk);
	my_dff d1(i_clk, slow_clk, i_input, Q1);
	my_dff d2(i_clk, slow_clk, Q1, Q2);
	assign o_output = Q1 & Q2;
endmodule

// Slow clock enable for debouncing button 
module clock_enable(input i_clk, output slow_clk);
    reg [16:0]counter=0;
    always @(posedge i_clk)
    begin
  		counter <= (counter >= 59999) ? 0 : counter + 1;
	end
    assign slow_clk = (counter == 59999) ? 1'b1 : 1'b0;
endmodule

// D-flip-flop with clock enable signal for debouncing module 
module my_dff(input DFF_CLOCK, input clock_enable, input D, output reg Q=0);
	always @ (posedge DFF_CLOCK) begin
  		if(clock_enable==1) 
        	Q <= D;
    end
endmodule