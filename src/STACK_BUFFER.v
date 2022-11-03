`timescale 1ns / 1ps

module STACK_BUFFER
  #(
   parameter DATA_WIDTH=4, // 
             ADDR_WIDTH=4  // number of address bits
  )
  (
   input  wire clk, reset, //CLOCK AND BUTTON
   input  wire pop, push, //BUTTONS
   input  wire [DATA_WIDTH-1:0] w_data, //SWITCH
   output wire full, //LED RED
   output wire [DATA_WIDTH-1:0] led,
   output wire ALMOST_EMPTY, ALMOST_FULL, //LED BLUE AND GREEN
   output wire [6:0] segment, //SEVEN SEGMENT
   output wire c //SELECT
  );
  
  wire empty;
  wire c_temp;
   
  wire[6:0] data_out;
  wire [ADDR_WIDTH-1:0] data_count;
  
  wire [DATA_WIDTH-1:0] r_data; //read data
  wire [ADDR_WIDTH-1:0] w_addr, r_addr; 
  wire push_en, full_tmp;
  
  reg[3:0] led_reg;
  reg[32:0] count = 0;
  reg[32:0] mega_count = 0;
  reg[3:0] led_temp;
  reg trigger;
  
  reg push_full, pop_full;  
  wire realpush, realpop;
  
  reg[3:0] num = 4'b0000; //0
  reg[3:0] decr = 4'b0000; //4
  
// body
  
  //  enabled only when FIFO is not full
  assign push_en = push_full & ~full_tmp;
  assign full = full_tmp;
  
  reg[32:0] count = 0;
  reg[32:0] count2 = 0;
  
  
  // instantiate fifo control unit
  STACK_CTRL #(.ADDR_WIDTH(ADDR_WIDTH), .BUFFER_SIZE(16)) c_unit
     (.clk(clk), .reset(reset), .pop(pop_full), .push(push_full), .empty(empty), .full(full_tmp), .w_addr(w_addr), .r_addr(r_addr),
     .ALMOST_EMPTY(ALMOST_EMPTY), .ALMOST_FULL(ALMOST_FULL), .data_count(data_count));

    REG_FILE_EXTENDED #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) u0(.clk(clk), .wr_en (push_en), .w_addr (w_addr ), .r_addr (r_addr ), .w_data(w_data), .r_data(r_data));
    
    DeBounce D0 (.Clock(clk), .Reset(reset), .button_in(push), .pulse_out(realpush));//push
    DeBounce D1 (.Clock(clk), .Reset(reset), .button_in(pop), .pulse_out(realpop));//pop
    
    
    SSD_DRIVER S0(.segment(data_out), .c(c_temp), .dig(data_count));
   
   
  always @(posedge clk)
  begin
 
 //reset block
    if(reset)
    begin
        led_reg <= 4'b0000;     
        push_full <= 1'b0;
        pop_full <= 1'b0;                 
    end
    
    else
    begin
 //block 1//  
        if(count==50000)
        begin
            push_full <= realpush;
            pop_full <= realpop;          
        end       
        else
            count<=count+1;
        
 //block 2//       
        if(realpop || r_addr || pop_full)
        begin      
            led_reg <= r_data;
        end //popfull
        else if(w_addr)
        begin
         
         //counter for delay
         if(count2==100000000)
            begin
            
            if(num==0 || num <= 4)
            begin     
                case(num)
                4'b0000: led_reg <= 4'b0001;
                4'b0001: led_reg <= 4'b0011;
                4'b0010: led_reg <= 4'b0111;
                4'b0011: led_reg <= 4'b1111;
                endcase        
                 
                num<=num+1;
                count2 <= 0;     
            end //num end
            
            else if(decr == 0 || decr <= 4)
            begin
                case(decr)
                4'b0000: led_reg <= 4'b1111;
                4'b0001: led_reg <= 4'b0111;
                4'b0010: led_reg <= 4'b0011;
                4'b0011: led_reg <= 4'b0001;
             endcase
             
                decr<=decr+1;
                count2<=0;
             end   //decr end
             
             else
                led_reg <= r_data;   
                
            end  //count2
           else    
                count2<=count2+1;                 
          end//push f
        
               
    end//else 
   
  end//always block
  

      
assign segment = data_out;
assign c = c_temp;
assign led = led_reg;






endmodule





