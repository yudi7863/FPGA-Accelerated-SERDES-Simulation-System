`timescale 1ns / 1ps

//outputs the convolution of the input signal with a pulse response of arbitrary length
module ISI_channel_prl#(
    //length of pulse response (UI) eg: if the pulse response is h = [1 0.5], PULSE_RESPONSE_LENGTH = 2
    parameter PULSE_RESPONSE_LENGTH,
    //bit-resolution of output signal
    parameter SIGNAL_RESOLUTION,
    //speration between symbols. eg: if SYMBOL seperation = 32, the pam-4 symbol set {0,1,2,3} should be mapped to {-48,-16,16,48}
    parameter SYMBOL_SEPERATION)(
    input clk,
    input rstn,
    input signed [SIGNAL_RESOLUTION-1:0] signal_in,
    input signal_in_valid,
    output reg signed [SIGNAL_RESOLUTION-1:0] signal_out,
    output reg signal_out_valid =0);
    
    // Sum of ISI terms
    reg signed [SIGNAL_RESOLUTION*2:0] isi [0:PULSE_RESPONSE_LENGTH-1];
    // First 16 bit stores m in m*2^y, last 16 bits stores y in m*2^y
    reg signed [31:0] pulse_response [0:PULSE_RESPONSE_LENGTH-1];

    initial begin
        $readmemb("../../Matlab_sim/Tx_sim/pulse_resp_appro.mem", pulse_response);
    end
    reg [SIGNAL_RESOLUTION*2 - 1:0] signal_in_signed;
    assign signal_in_signed = (signal_in[SIGNAL_RESOLUTION-1] == 1'b1) ? {{(SIGNAL_RESOLUTION){1'b1}},signal_in} : {{(SIGNAL_RESOLUTION){1'b0}},signal_in};
    always @ (posedge clk) begin
        if (!rstn) begin
            signal_out_valid <= 0;
            // Initialize to zeros
            for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                isi[i] <= 'b0;
            end
        end else begin
            if(signal_in_valid) begin
                // Updates the sum of ISI terms
                for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                    if (i == PULSE_RESPONSE_LENGTH-1) begin
                        isi[i] <= signal_in_signed * pulse_response[i][31:16];
                    end
                    else begin
                        isi[i] <= isi[i+1] + signal_in_signed * pulse_response[i][31:16];
                    end
                end

                // Output
                signal_out <= (isi[1] + signal_in_signed * pulse_response[0][31:16]) >>> pulse_response[0][15:0];
                signal_out_valid <= 1;
            end else begin
                signal_out_valid <= 0;
            end
        end
    end
endmodule