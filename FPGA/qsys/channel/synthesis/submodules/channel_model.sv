`timescale 1ns / 1ps

//outputs the convolution of the input signal with a pulse response of arbitrary length
module ISI_channel#(
    //length of pulse response (UI) eg: if the pulse response is h = [1 0.5], PULSE_RESPONSE_LENGTH = 2
    parameter PULSE_RESPONSE_LENGTH = 2,
    //bit-resolution of output signal
    parameter SIGNAL_RESOLUTION = 8,
    //speration between symbols. eg: if SYMBOL seperation = 32, the pam-4 symbol set {0,1,2,3} should be mapped to {-48,-16,16,48}
    parameter SYMBOL_SEPERATION = 56)(
    input clk,
    input rstn,
    input signed [SIGNAL_RESOLUTION-1:0] signal_in,
    input signal_in_valid,
    output reg signed [SIGNAL_RESOLUTION-1:0] signal_out,
    output reg signal_out_valid =0);
    
    logic [SIGNAL_RESOLUTION*(PULSE_RESPONSE_LENGTH-1)-1:0] isi_effect;

    //take signal_in, multiply
    always @ (posedge clk) begin
        if (!rstn) begin
            signal_out_valid <= 0;
            isi_effect <= {({SIGNAL_RESOLUTION*(PULSE_RESPONSE_LENGTH-1){1'b0}})}; // Initialize to all zeros
        end else begin
            if(signal_in_valid) begin
                signal_out <= signal_in + isi_effect;
                isi_effect <= signal_in >>> 1;
                signal_out_valid <= 1;
            end else begin
                signal_out_valid <= 0;
            end
        end
    end
endmodule