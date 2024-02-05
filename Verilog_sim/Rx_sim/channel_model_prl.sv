`timescale 1ns / 1ps

//outputs the convolution of the input signal with a pulse response of arbitrary length
module ISI_channel_prl#(
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
    
    logic [SIGNAL_RESOLUTION-1:0] isi_effect;

    integer row_ptr;
    integer row;
    reg [SIGNAL_RESOLUTION-1:0] isi [0:PULSE_RESPONSE_LENGTH-1] [0:PULSE_RESPONSE_LENGTH-1];

    //take signal_in, multiply
    always @ (posedge clk) begin
        if (!rstn) begin
            signal_out_valid <= 0;
            row_ptr <= 0;
            row <= 0;
            isi_effect <= 'b0;
            // Initialize to all zeros
            for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                for (int j = 0; j < PULSE_RESPONSE_LENGTH; j++) begin
                    isi[i][j] <= 'b0;
                end
            end
        end else begin
            if(signal_in_valid) begin
                // Prepare output
                for (int ptr = 0; ptr < PULSE_RESPONSE_LENGTH; ptr++) begin
                    if (row == PULSE_RESPONSE_LENGTH - 1) begin
                        row <= 0;
                    end
                    else begin
                        row <= row_ptr + ptr + 1;
                    end
                    isi_effect <= isi_effect + isi[row][PULSE_RESPONSE_LENGTH - 1 - ptr];
                end
                signal_out <= signal_in + isi_effect;

                // Record ISI terms
                for (int k = 0; k < PULSE_RESPONSE_LENGTH; k++) begin
                    isi[row_ptr][k] <= signal_in >>> 1; // Read memory and modify
                end

                // will this work?
                if (row_ptr == PULSE_RESPONSE_LENGTH - 1) begin
                    row_ptr <= 0;
                end 
                else begin
                row_ptr <= row_ptr + 1;
                end
                signal_out_valid <= 1;
            end else begin
                signal_out_valid <= 0;
            end
        end
    end
endmodule