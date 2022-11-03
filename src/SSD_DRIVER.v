//Shahbaz Hassan Khan Malik

`timescale 1ns / 1ps

module SSD_DRIVER(
input wire[3:0] dig,
output wire [6:0] segment,
output wire c
    );
 
reg[6:0] segment_reg;
reg c_reg;

always @*
begin
case (dig[3:0])
      4'b0000: segment_reg = 7'b1111110;
      4'b0001: segment_reg = 7'b0110000;
      4'b0010: segment_reg = 7'b1101101;
      4'b0011: segment_reg = 7'b1111001;
      4'b0100: segment_reg = 7'b0110011;
      4'b0101: segment_reg = 7'b1011011;
      4'b0110: segment_reg = 7'b1011111;
      4'b0111: segment_reg = 7'b1110000;
      4'b1000: segment_reg = 7'b1111111;
      4'b1001: segment_reg = 7'b1110011;
      4'b1010: segment_reg = 7'b1110111;
      4'b1011: segment_reg = 7'b0011111;
      4'b1100: segment_reg = 7'b1001110;
      4'b1101: segment_reg = 7'b0111101;
      4'b1110: segment_reg = 7'b1001111;
      4'b1111: segment_reg = 7'b1000111;
      default : segment_reg = 7'b1001110;
    endcase 
end

always@*
c_reg <= 0;


assign c = c_reg;
assign segment = segment_reg;

endmodule
