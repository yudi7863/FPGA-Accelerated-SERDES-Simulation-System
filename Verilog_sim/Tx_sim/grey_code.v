`timescale 1ns / 1ps

module grey_encode(
    input clk,
    input rstn,
    input data_in,
    input data_in_valid,
    output reg [1:0] symbol_out,
    output reg symbol_out_valid =0);
    
    //shift register to store 2 bits input data
    reg [1:0] sr = 'b00;
    
    // bit_idx = 0 if no valid data is in sr
    // bit_idx = 1 if 1 bit valid data is in sr
    // bit_idx = 2 if 2 bits valid data is in sr
    reg [1:0] bit_idx = 0;
    
    
    always @ (posedge clk)
        
        //reset
        if (!rstn) begin
            symbol_out_valid <= 0;
            bit_idx <= 0;
            sr <= 'b00;
            
        end else begin
        
            if (data_in_valid) begin
                // shift valid data into sr
                sr <= {sr[0],data_in};
                
                //2-bit symbol is not yet loaded in
                if (bit_idx == 0) begin
                    bit_idx <=1;
                    symbol_out_valid <= 0;
                end else if (bit_idx == 1) begin
                    bit_idx <=2;
                    symbol_out_valid <= 0;         
                    
                //2-bit symbol is loaded, output corresponding grey-coded symbol    
                end else if (bit_idx == 2) begin
                    case(sr)
                        2'b00: symbol_out <= 2'b00;
                        2'b01: symbol_out <= 2'b01;
                        2'b11: symbol_out <= 2'b10;
                        2'b10: symbol_out <= 2'b11;
                    endcase

                    bit_idx <= 1;
                    symbol_out_valid <= 1;
                end
            end else begin
            symbol_out_valid <=0;
        end 
    end     
endmodule


module grey_decode(
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
    
    always @ (posedge clk)
        
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
    
