`timescale 1ns / 1ps

module prbs_grey_code_tb;

    reg clk = 0;
    reg en = 0;
    reg rstn = 0;
    
    
    //generate random data
    wire binary_data;
    wire binary_data_valid;
    
    prbs31 prbs (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .data_out(binary_data),
        .data_out_valid(binary_data_valid));
    
    //form grey-coded PAM-4 symbols
    
    wire [1:0] symbol;
    wire symbol_valid;
    
    grey_encode ge (
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data),
	    .data_in_valid(binary_data_valid),
        .symbol_out(symbol),
        .symbol_out_valid(symbol_valid));
        
    //decode pam-4 symbols back to binary data
    
    wire binary_data_r;
    wire binary_data_r_valid;
    
    grey_decode gd (
        .clk(clk),
        .rstn(rstn),
        .symbol_in(symbol),
	    .symbol_in_valid(symbol_valid),
        .data_out(binary_data_r),
        .data_out_valid(binary_data_r_valid));	   
	           
    //check to make received binary data matches prbs sequence
    
    wire [31:0] total_bits;
    wire [31:0] total_bit_errors;
    
   /* prbs31_checker checker (
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data_r),
        .data_in_valid(binary_data_r_valid),
        .total_bits(total_bits),
        .total_bit_errors(total_bit_errors));*/
           
	           
    always #10 clk = ~clk;
    
    initial begin
        #50 
        en <= 1;
        rstn <=1;
        #2120
        //$display("\nBits Transmitted:%d", total_bits);
        //$display("\nBit Errors:%d", total_bit_errors);
        $finish;
    end

endmodule
   
