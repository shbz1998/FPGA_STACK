`timescale 1ns / 1ps

module STACK_CTRL
  #(
   parameter ADDR_WIDTH=4,
   parameter BUFFER_SIZE = 16  // number of address bits
  )
  (
   input  wire clk, reset,
   input  wire pop, push,
   output wire empty, full,
   output wire [ADDR_WIDTH-1:0] w_addr,
   output wire [ADDR_WIDTH-1:0] r_addr,
   
   output wire [ADDR_WIDTH-1:0] data_count, 
   output wire  ALMOST_FULL, ALMOST_EMPTY
  );

  //signal declaration
  reg [ADDR_WIDTH-1:0] w_ptr_logic, w_ptr_next, w_ptr_succ;
  reg [ADDR_WIDTH-1:0] r_ptr_logic, r_ptr_next, r_ptr_succ;
  reg full_logic, empty_logic, full_next, empty_next;
  
  reg ALMOST_FULL_ff_nxt, ALMOST_EMPTY_ff_nxt;
  reg ALMOST_FULL_ff, ALMOST_EMPTY_ff;
  reg [ADDR_WIDTH : 0]		DATA_REG, DATA_NEXT;
  reg DATA_ADD, DATA_SUB;

localparam  ALMOST_FULL_FLAG=BUFFER_SIZE*3/4, ALMOST_EMPTY_FLAG=BUFFER_SIZE*1/4;

 always @(posedge clk, posedge reset)
     if (reset)
        begin
           w_ptr_logic <= 0;
           r_ptr_logic <= 0;
           full_logic <= 1'b0;
           empty_logic <= 1'b1;
           
           ALMOST_FULL_ff <= 1'b0;
           ALMOST_EMPTY_ff <= 1'b1;
           DATA_REG <= 0;
        end
     else
        begin
           w_ptr_logic <= w_ptr_next;
           r_ptr_logic <= r_ptr_next;
           full_logic <= full_next;
           empty_logic <= empty_next;
           
           ALMOST_FULL_ff <= ALMOST_FULL_ff_nxt;
           ALMOST_EMPTY_ff <= ALMOST_EMPTY_ff_nxt;
           DATA_REG <= DATA_NEXT;
        end


always @ ( ALMOST_EMPTY_ff, ALMOST_FULL_ff, DATA_REG)
	   begin
			ALMOST_EMPTY_ff_nxt = ALMOST_EMPTY_ff;
			ALMOST_FULL_ff_nxt = ALMOST_FULL_ff;						
			if(DATA_REG == ALMOST_EMPTY_FLAG)
				ALMOST_EMPTY_ff_nxt = 1'b 1;
			else
				ALMOST_EMPTY_ff_nxt = 1'b 0;

			if(DATA_REG == ALMOST_FULL_FLAG)
				ALMOST_FULL_ff_nxt = 1'b 1;
			else
				ALMOST_FULL_ff_nxt = 1'b 0;			
		end


always@*
  begin
     // successive pointer values
     w_ptr_succ = w_ptr_logic + 1;
     r_ptr_succ = r_ptr_logic - 1;
     // default: keep old values
     w_ptr_next = w_ptr_logic;
     r_ptr_next = r_ptr_logic;
     full_next = full_logic;
     empty_next = empty_logic;
     
     DATA_ADD = 1'b0;
     DATA_SUB = 1'b0;
     
     case ({push, pop})
        2'b01: // read
           if (~empty_logic) // not empty
              begin
                if(DATA_REG > 0 )
                    DATA_SUB = 1'b1;
                 else
                    DATA_SUB = 1'b0;
                    
                 r_ptr_next = r_ptr_succ;
                 full_next = 1'b0;
                 if (r_ptr_succ==w_ptr_logic)
                    empty_next = 1'b1;
              end
        2'b10: // 
           if (~full_logic) // not full
              begin
                 DATA_ADD = 1'b1;
                 w_ptr_next = w_ptr_succ;
                 empty_next = 1'b0;
                 if (w_ptr_succ==r_ptr_logic)
                    full_next = 1'b1;
              end
        2'b11: //  and read
           begin
              w_ptr_next = w_ptr_succ;
              r_ptr_next = r_ptr_succ;
           end
        default: ;  // 2'b00; null statement; no op
     endcase
  end
 
 always @ ( DATA_SUB, DATA_ADD, DATA_REG)
		begin	
			case( {DATA_SUB , DATA_ADD} )
				2'b 01 :
						DATA_NEXT = DATA_REG + 1;
				2'b 10 :
						DATA_NEXT = DATA_REG - 1;
				default :
						DATA_NEXT = DATA_REG;
			endcase 	
end	
  
//  always @(w_ptr_logic, r_ptr_logic)
//  begin
//  $display("read %d", r_ptr_logic);
//  end
  
  // output
  assign w_addr = w_ptr_logic;
  assign r_addr = r_ptr_logic;
  assign full = full_logic;
  assign empty = empty_logic;
  
  
  assign ALMOST_EMPTY = ALMOST_EMPTY_ff; 
  assign ALMOST_FULL = ALMOST_FULL_ff;
  assign data_count = DATA_REG;
endmodule
