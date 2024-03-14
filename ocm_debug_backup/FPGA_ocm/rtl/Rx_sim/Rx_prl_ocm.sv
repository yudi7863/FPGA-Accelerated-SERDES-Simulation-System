`timescale 1ns / 1ps

module DFE_prl #(
    parameter PULSE_RESPONSE_LENGTH = 5,
    parameter SIGNAL_RESOLUTION = 8,
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

    // Sum of ISI terms
    reg signed [SIGNAL_RESOLUTION*2:0] isi [0:PULSE_RESPONSE_LENGTH-1];
    // First 8 bit stores m in m*2^y, last 8 bits stores y in m*2^y
    reg signed [SIGNAL_RESOLUTION*4-1:0] pulse_response [0:PULSE_RESPONSE_LENGTH-1];

    //shift register
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] subtract_result;
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] feedback_value;
    logic f_valid;
    logic e_valid;
    decision_maker_prl DM (
        .clk(clk), 
        .rstn(rstn), 
        .estimation(subtract_result),
        .feedback_value(feedback_value),
        .e_valid(e_valid),
        .f_valid(f_valid)
    );

   /* initial begin
        $readmemb("../../Matlab_sim/Tx_sim/pulse_resp_appro.mem", pulse_response);
    end*/

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
                pulse_response[i] <= mem_data;
                count <= count + 'b1;
            end
            if(count == PULSE_RESPONSE_LENGTH +2) begin //two cycles late...
                //load_mem <= 'b0; this needs to be controlled outside..
                done_wait <= 'b1;
            end
        end
    end


    always_ff @ (posedge clk) begin
        if(!rstn) begin
            e_valid <= 'b0;
            subtract_result <='b0;
            signal_out_valid <= 'b0;
            signal_out <= 'b0;
            for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                isi[i] <= 'b0;
            end
        end
        else begin
            if(signal_in_valid == 'b1 && !load_mem && done_wait) begin
                signal_out <= feedback_value;
                for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                    if (i == PULSE_RESPONSE_LENGTH-1) begin
                        isi[i] = feedback_value * pulse_response[i][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2];
                    end
                    else begin
                        isi[i] = isi[i+1] + feedback_value * pulse_response[i][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2];
                    end
                end
                subtract_result <= ((signal_in <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - isi[1]) / pulse_response[0][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2];
                e_valid <= 'b1;
            end
            else begin 
                e_valid <='b0;
            end

            // change this
            if(f_valid == 'b1) begin
                signal_out_valid <= ~signal_out_valid;
            end
        end
    end
endmodule
