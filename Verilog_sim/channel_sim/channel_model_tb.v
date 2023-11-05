`timescale 1ns / 1ps

module channel_model_tb;
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
    wire signal_valid;
    ISI_channel PRBS_channel (
        .clk(clk),
        .rstn(rstn),
        .signal_in(voltage_level),
        .signal_in_valid(voltage_level_valid),
        .signal_out(voltage_level_isi),
        .signal_out_valid(signal_valid));
    //setting clock:
    always #10 clk = ~clk;
    //starting simulation:
    initial begin
        
        #50 
        en <= 1;
        rstn <=1;
        #2120
        
        $finish;

        
    end

endmodule