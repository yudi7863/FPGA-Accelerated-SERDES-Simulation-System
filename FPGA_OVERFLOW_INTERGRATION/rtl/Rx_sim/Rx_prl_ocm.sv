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
    reg signed [31:0] pulse_response [0:PULSE_RESPONSE_LENGTH-1] /* synthesis preserve*/ ;

    //shift register
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] subtract_result /* synthesis preserve*/ ;
    logic signed [SIGNAL_RESOLUTION-1:0] feedback_value /* synthesis preserve*/ ;
    //logic signed [SIGNAL_RESOLUTION*2-1:0] pulse_response_upper, pulse_response_lower; 
	logic signed [16:0] pulse_response_upper, pulse_response_lower /* synthesis preserve*/; 
    logic f_valid;
    logic e_valid;

    //reg [SIGNAL_RESOLUTION*2 - 1:0] signal_in_signed;
    //assign signal_in_signed = (signal_in[SIGNAL_RESOLUTION-1] == 1'b1) ? {{(SIGNAL_RESOLUTION){1'b1}},signal_in} : {{(SIGNAL_RESOLUTION){1'b0}},signal_in};

    decision_maker_prl #(.PULSE_RESPONSE_LENGTH(PULSE_RESPONSE_LENGTH),.SIGNAL_RESOLUTION(SIGNAL_RESOLUTION), .SYMBOL_SEPERATION(SYMBOL_SEPERATION)) DM (
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

    logic [7:0] i;
    logic [7:0] count;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            done_wait <= 1'b0;
            i <= 8'b0;
            count <= 1'b0;
        end
        else begin
            if(load_mem) begin 
                i <= location;
                //need to make sure that i is a valid location...
                pulse_response[i] <= mem_data[31:0];
                count <= count + 8'b1;
            end
            if(count == PULSE_RESPONSE_LENGTH +2) begin //two cycles late...
                //load_mem <= 'b0; this needs to be controlled outside..
                done_wait <= 1'b1;
            end
        end
    end

	 logic signed [55:0] temp_signal/* synthesis preserve*/;
    //logic [SIGNAL_RESOLUTION*2-1:0] negate_signal/* synthesis preserve*/;
    //logic [SIGNAL_RESOLUTION*2-1:0] division/* synthesis preserve*/;
    //logic negative_or_not/* synthesis preserve*/;
    assign pulse_response_upper = pulse_response[1][31:16];
    assign pulse_response_lower = pulse_response[0][15:0];
    //assign temp_signal = (signal_in <<< pulse_response_lower)  - (((PULSE_RESPONSE_LENGTH > 2) ? isi[2] : {SIGNAL_RESOLUTION*2{1'b0}}) + feedback_value * pulse_response_upper);
	 assign temp_signal = (PULSE_RESPONSE_LENGTH > 2) ? ((signal_in <<< pulse_response_lower) - (isi[2] + feedback_value * pulse_response_upper)) : ((signal_in <<< pulse_response_lower) - (feedback_value * pulse_response_upper));
    //assign negate_signal = (temp_signal[SIGNAL_RESOLUTION*2-1] == 1'b1) ? (~(temp_signal-1'b1)) : temp_signal;
    //assign negative_or_not = (temp_signal[SIGNAL_RESOLUTION*2-1] == 1'b1) ? 1'b1 : 1'b0;
    //assign division = negate_signal >>> pulse_response[0][SIGNAL_RESOLUTION*2-1:0];/// pulse_response[0][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2];
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
                signal_out <= feedback_value[SIGNAL_RESOLUTION-1:0];
                for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                    if (i == PULSE_RESPONSE_LENGTH-1) begin
                        isi[i] <= feedback_value * pulse_response[i][31:16];
                    end
                    else begin
                        isi[i] <= isi[i+1] + feedback_value* pulse_response[i][31:16];
                    end
                end
                //subtract_result <= ((signal_in_signed <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - isi[1]) / pulse_response[0][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2];
                //subtract_result <= (((signal_in <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - isi[1]) & 17'h10000) ? ~(((~(((signal_in <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - isi[1])-1'b1)) / pulse_response[0][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2])-1'b1) : (((signal_in <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - isi[1]) / pulse_response[0][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2]);
					 subtract_result <= (temp_signal >>> pulse_response_lower); //(temp_signal[SIGNAL_RESOLUTION*2-1] == 1'b1) ? (~((~(temp_signal-1'b1)) >>> pulse_response[0][SIGNAL_RESOLUTION*2-1:0])+1'b1 ): (temp_signal >>> pulse_response[0][SIGNAL_RESOLUTION*2-1:0]);//(negative_or_not) ? (~division)+1'b1  : division;
					 //subtract_result <= (PULSE_RESPONSE_LENGTH > 2) ? (((signal_in <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - (isi[2] + feedback_value * pulse_response[1][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2])) >>> pulse_response[0][15:0]): (((signal_in <<< pulse_response[0][SIGNAL_RESOLUTION*2-1:0]) - (feedback_value * pulse_response[1][SIGNAL_RESOLUTION*4-1:SIGNAL_RESOLUTION*2])) >>> pulse_response[0][15:0]);
					 
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
