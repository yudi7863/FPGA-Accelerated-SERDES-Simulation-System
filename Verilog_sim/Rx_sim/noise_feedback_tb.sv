`timescale 1ns / 1ps
module noise_feedback_tb;
    reg clk = 0;
    reg en = 0;
    reg rstn = 0;

    // generate data through prbs->grey_code->pam_4
    // Generate random data
    wire binary_data;
    wire binary_data_valid;
    prbs31 prbs(
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .data_out(binary_data),
        .data_out_valid(binary_data_valid));
    
    // Generate grey-coded PAM-4 symbols
    wire [1:0] symbol;
    wire symbol_valid;
    grey_encode ge(
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

    wire [7:0] voltage_level_isi;
    wire voltage_level_isi_valid;
    ISI_channel channel (
        .clk(clk),
        .rstn(rstn),
        .signal_in(voltage_level),
        .signal_in_valid(voltage_level_valid),
        .signal_out(voltage_level_isi),
        .signal_out_valid(voltage_level_isi_valid));

/*

    ///////////////noise///////////////
    wire [7:0] noise_output;
    wire noise_valid;
    // noise_wrapper noise_wrapper_noise (
    //         .clk(clk),
    //         .en(en),
    //         .rstn(rstn),
    //         .noise_in(voltage_level_isi),
    //         .noise_in_valid(voltage_level_isi_valid),
    //         .noise_out(noise_output),
    //         .noise_out_valid(noise_valid)
    // );

    noise_128_wrapper noise_wrapper_noise (
            .clk(clk),
            .en(en),
            .rstn(rstn),
            .noise_in(voltage_level_isi),
            .noise_in_valid(voltage_level_isi_valid),
            .noise_out(noise_output),
            .noise_out_valid(noise_valid)
    );
    //////////////////////////////////////



    wire [7:0] voltage_level_dfe;
    wire voltage_level_dfe_valid;
    DFE #(.PULSE_RESPONSE_LENGTH(2), .SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) rx(
        .clk(clk),
        .rstn(rstn),
        .signal_in(noise_output),
        .signal_in_valid(noise_valid),
        .signal_out(voltage_level_dfe),
        .signal_out_valid(voltage_level_dfe_valid));

    wire [1:0] symbol_rx;
    wire symbol_rx_valid;
    pam_4_decode #(.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) pd(
        .clk(clk),
        .rstn(rstn),
        .voltage_level_in(voltage_level_dfe),
	    .voltage_level_in_valid(voltage_level_dfe_valid),
        .symbol_out(symbol_rx),
        .symbol_out_valid(symbol_rx_valid));

    wire binary_data_rx;
    wire binary_data_rx_valid;
    grey_decode gd(
        .clk(clk),
        .rstn(rstn),
        .symbol_in(symbol_rx),
	    .symbol_in_valid(symbol_rx_valid),
        .data_out(binary_data_rx),
        .data_out_valid(binary_data_rx_valid));

    wire [31:0] total_bits;
    wire [31:0] total_bit_errors;
    prbs31_checker ebr(
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data_rx),
        .data_in_valid(binary_data_rx_valid),
        .total_bits(total_bits),
        .total_bit_errors(total_bit_errors));
*/           
    //setting clock:
    always #10 clk = ~clk;
    //starting simulation:
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