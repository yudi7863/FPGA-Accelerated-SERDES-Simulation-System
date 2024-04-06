module grey_decode_INT(
    input clk,
    input rstn,
    input [1:0] symbol_in,
    input symbol_in_valid,
    output data_out,
    output reg data_out_valid = 0);
    
    //stores most recent grey-decoded valid symbol
    reg [1:0] cur_symbol;
    
    //index of cur symbol to output
    reg bit_idx = 0;
    
    assign data_out = cur_symbol[bit_idx];
    
    always @ (posedge clk  or negedge rstn)
        
        //reset
        if (!rstn) begin
            data_out_valid <= 0;
            bit_idx <= 0;
            
        end else begin
        
            //take in new valid symbol and decode it
            if (symbol_in_valid) begin
                case(symbol_in)
                    2'b00: cur_symbol <= 2'b00;
                    2'b01: cur_symbol <= 2'b01;
                    2'b11: cur_symbol <= 2'b10;
                    2'b10: cur_symbol <= 2'b11;
                endcase
                bit_idx <= 1;
                data_out_valid <= 1;
            
            //decrement bit_idx
            end else if (bit_idx ==1) begin
                bit_idx <= 0;
                data_out_valid <= 1;
            end else begin
                data_out_valid <= 0;
        end
    end
        
endmodule
    
