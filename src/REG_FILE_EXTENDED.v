`timescale 1ns / 1ps

module REG_FILE_EXTENDED #(parameter ADDR_WIDTH=8, DATA_WIDTH=2)
( 
input wire clk,
input wire wr_en,
input wire [ADDR_WIDTH-1:0] w_addr, r_addr,
input wire [DATA_WIDTH-1:0] w_data,
output wire [DATA_WIDTH-1:0] r_data
);

reg[DATA_WIDTH-1:0] array_reg[0:2**ADDR_WIDTH-1];

always @(posedge clk)
    begin
        if(wr_en)
            array_reg[w_addr] <= w_data;
//     $display("data at %d, is %d", w_addr, w_data);       
    end

assign r_data = array_reg[r_addr];




endmodule