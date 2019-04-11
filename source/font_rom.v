module font_rom (input i_clk,
                 input [3:0] i_addr,
                 output reg [6:0] o_data);

  reg [3:0] addr_reg; 

  // body
  always @(posedge i_clk) begin
     addr_reg <= i_addr;
  end

  always @(addr_reg) begin
    case (addr_reg)
      4'd0: o_data = 7'b1110111;
      4'd1: o_data = 7'b0100100;
      4'd2: o_data = 7'b1011101;
      4'd3: o_data = 7'b1101101;
      4'd4: o_data = 7'b0101110;
      4'd5: o_data = 7'b1101011;
      4'd6: o_data = 7'b1111011;
      4'd7: o_data = 7'b0100101;
      4'd8: o_data = 7'b1111111;
      4'd9: o_data = 7'b0101111;
      
      4'd10: o_data = 7'b0110110;
      4'd11: o_data = 7'b0110110;
      4'd12: o_data = 7'b0110110;
      4'd13: o_data = 7'b0110110;
      4'd14: o_data = 7'b0110110;
      4'd15: o_data = 7'b0110110;
    endcase
  end

endmodule