`timescale 1ns / 1ps

//outputs the convolution of the input signal with a pulse response of arbitrary length
module ISI_channel_ocm#(
    //length of pulse response (UI) eg: if the pulse response is h = [1 0.5], PULSE_RESPONSE_LENGTH = 2
    parameter PULSE_RESPONSE_LENGTH = 3,
    //bit-resolution of output signal
    parameter SIGNAL_RESOLUTION = 8,
    //speration between symbols. eg: if SYMBOL seperation = 32, the pam-4 symbol set {0,1,2,3} should be mapped to {-48,-16,16,48}
    parameter SYMBOL_SEPERATION = 56)(
    input clk,
    input rstn,
    input signed [SIGNAL_RESOLUTION-1:0] signal_in,
    input signal_in_valid,
    output reg signed [SIGNAL_RESOLUTION-1:0] signal_out,
    output reg signal_out_valid =0,
    input load_mem,
    output reg done_wait,
    input [7:0] location,
    input [63:0] mem_data);
    
    // Stores input voltage * h
    reg [SIGNAL_RESOLUTION*2-1:0] individual_isi [0:PULSE_RESPONSE_LENGTH-1];
    // Sum of ISI terms
    reg [SIGNAL_RESOLUTION-1:0] isi [0:PULSE_RESPONSE_LENGTH-1];
    // First 8 bit stores m in m*2^y, last 8 bits stores y in m*2^y
    reg [SIGNAL_RESOLUTION*2-1:0] pulse_response [0:PULSE_RESPONSE_LENGTH-1];

   // initial begin 
   //     $readmemb("../../Matlab_sim/Tx_sim/pulse_resp_appro.mem", pulse_response);
   // end

    //loading from mem:
    //loading from mem:
    integer i;
    logic [7:0] count;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            done_wait <= 'b0;
            i <= 'b0;
            count <= 'b0;
        end
        else begin
            if(load_mem) begin 
                i <= location;
                //need to make sure that i is a valid location...
                pulse_response[i] <= mem_data[SIGNAL_RESOLUTION:0];
                count <= count + 'b1;
            end
            if(count == PULSE_RESPONSE_LENGTH +2) begin //two cycles late...
                //load_mem <= 'b0; this needs to be controlled outside..
                done_wait <= 'b1;
            end
        end
    end


    always @ (posedge clk) begin
        if (!rstn) begin
            signal_out_valid <= 0;
            // Initialize to zeros
            for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                individual_isi[i] <='b0;
                isi[i] <= 'b0;
            end
        end else begin
            if(signal_in_valid && !load_mem && done_wait) begin
                // Calculates ISI from an individual voltage level using blocking statement
                for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                    if (!signal_in[SIGNAL_RESOLUTION-1]) begin
                        individual_isi[i] = signal_in * pulse_response[i][SIGNAL_RESOLUTION*2-1:SIGNAL_RESOLUTION] >>> pulse_response[i][SIGNAL_RESOLUTION-1:0];
                    end
                    else begin
                        // modify this concatenation
                        individual_isi[i] = $signed({8'b11111111, signal_in} * pulse_response[i][SIGNAL_RESOLUTION*2-1:SIGNAL_RESOLUTION]) >>> pulse_response[i][SIGNAL_RESOLUTION-1:0];
                    end
                end

                // Updates the sum of ISI terms
                for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                    if (i == PULSE_RESPONSE_LENGTH-1) begin
                        isi[i] <= individual_isi[i][SIGNAL_RESOLUTION-1:0];
                    end
                    else begin
                        isi[i] <= isi[i+1] + individual_isi[i][SIGNAL_RESOLUTION-1:0];
                    end
                end

                // Output 
                signal_out <= isi[1] + individual_isi[0][SIGNAL_RESOLUTION-1:0];
                signal_out_valid <= 1;
            end else begin
                signal_out_valid <= 0;
            end
        end
    end
endmodule