`timescale 1ns / 1ps

module orig_channel_tb;

     //import signals for the ISI_channel:
    parameter PULSE_RESPONSE_LENGTH = 3;
    parameter SIGNAL_RESOLUTION = 8;
    parameter SYMBOL_SEPERATION = 56;
    logic clk, rstn;
    logic [SIGNAL_RESOLUTION-1:0] signal_in,signal_out;
    logic signal_valid;
    logic signal_out_valid;
     always #10 clk = ~clk;


     //dut simulation:
    ISI_channel_prl ISI_channel_prl (
        .clk(clk),
        .rstn(rstn),
        .signal_in(signal_in),
        .signal_out(signal_out),
        .signal_in_valid(signal_valid),
        .signal_out_valid(signal_out_valid)
    );


     initial begin
        clk = 0;
        rstn = 0;
        #20
        rstn = 1;
        #1000;
        $finish();
     end
endmodule