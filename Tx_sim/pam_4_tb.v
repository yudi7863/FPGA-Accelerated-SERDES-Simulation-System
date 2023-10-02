`timescale 1ns / 1ps

module prbs_pam_4_tb;
    reg clk = 0;
    reg en = 0;
    reg rstn = 0;

    // Generate random data
    wire binary_data;
    wire binary_data_valid;
    prbs31 prbs (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .data_out(binary_data),
        .data_out_valid(binary_data_valid));
    
    // Generate grey-coded PAM-4 symbols
    wire [1:0] symbol;
    wire symbol_valid;
    grey_encode ge (
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data),
	    .data_in_valid(binary_data_valid),
        .symbol_out(symbol),
        .symbol_out_valid(symbol_valid));

    // Generate voltage levels
    wire [7:0] voltage_level;
    wire voltage_level_valid;
    pam_4_encode #(.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) pe(
        .clk(clk),
        .rstn(rstn),
        .symbol_in(symbol),
	    .symbol_in_valid(symbol_valid),
        .voltage_level_out(voltage_level),
        .voltage_level_out_valid(voltage_level_valid));
    
    // Decode voltage levels back to PAM-4 symbols
    wire [1:0] symbol_returned;
    wire symbol_returned_valid;
    pam_4_decode #(.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) pd(
        .clk(clk),
        .rstn(rstn),
        .voltage_level_in(voltage_level),
	    .voltage_level_in_valid(voltage_level_valid),
        .symbol_out(symbol_returned),
        .symbol_out_valid(symbol_returned_valid));
    
    // Decode PAM-4 symbols back to binary data
    wire binary_data_returned;
    wire binary_data_returned_valid;
    grey_decode gd (
        .clk(clk),
        .rstn(rstn),
        .symbol_in(symbol_returned),
	    .symbol_in_valid(symbol_returned_valid),
        .data_out(binary_data_returned),
        .data_out_valid(binary_data_returned_valid));
    
    // Compare returned data with generated data
    wire [31:0] total_bits;
    wire [31:0] total_bit_errors;
    prbs31_checker checker (
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data_returned),
        .data_in_valid(binary_data_returned_valid),
        .total_bits(total_bits),
        .total_bit_errors(total_bit_errors));
          
    always #10 clk = ~clk;
    
    initial begin
        #50 
        en <= 1;
        rstn <=1;
        #2120
        $display("\nBits Transmitted:%d", total_bits);
        $display("\nBit Errors:%d", total_bit_errors);
        $finish;
    end
endmodule