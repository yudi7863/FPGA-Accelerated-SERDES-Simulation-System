`timescale 1ns / 1ps

module DFE_prl #(
    parameter PULSE_RESPONSE_LENGTH,
    parameter SIGNAL_RESOLUTION,
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
    reg signed [SIGNAL_RESOLUTION*4-1:0] pulse_response [0:PULSE_RESPONSE_LENGTH-1];

    //shift register
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] subtract_result;
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] feedback_value;
    logic f_valid;
    logic e_valid;
    decision_maker_prl #(.PULSE_RESPONSE_LENGTH(PULSE_RESPONSE_LENGTH), .SIGNAL_RESOLUTION(SIGNAL_RESOLUTION), .SYMBOL_SEPERATION(SYMBOL_SEPERATION)) DM (
        .clk(clk), 
        .rstn(rstn), 
        .estimation(subtract_result),
        .feedback_value(feedback_value),
        .e_valid(e_valid),
        .f_valid(f_valid)
    );

    initial begin
        $readmemb("../../Matlab_sim/Tx_sim/pulse_resp_appro.mem", pulse_response);
    end

    always_ff @ (posedge clk) begin
        if(!rstn) begin
            e_valid <= 'b0;
            subtract_result <='b0;
            feedback_value <='b0;
            signal_out_valid <= 'b0;
            signal_out <= 'b0;
            for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                isi[i] <= 'b0;
            end
        end
        else begin
            if(signal_in_valid == 'b1) begin
                signal_out <= feedback_value;
                for (int i = 0; i < PULSE_RESPONSE_LENGTH; i++) begin
                    if (i == PULSE_RESPONSE_LENGTH-1) begin
                        isi[i] = feedback_value * pulse_response[i][31:16];
                    end
                    else begin
                        isi[i] = isi[i+1] + feedback_value * pulse_response[i][31:16];
                    end
                end
                subtract_result <= ((signal_in <<< pulse_response[0][15:0]) - isi[1]) / pulse_response[0][31:16];
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

module decision_maker_prl #(
    parameter PULSE_RESPONSE_LENGTH,
    parameter SIGNAL_RESOLUTION,
    parameter SYMBOL_SEPERATION) 
(   input clk,
    input rstn,
    input signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] estimation, 
    input e_valid,
    output signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] feedback_value,
    output logic f_valid
    );
    //the four values that we want
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] value [3:0];
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] difference [3:0];
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] best_value;
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] best_difference;
    logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] feedback_value_i;
    assign feedback_value = feedback_value_i;
    //logic [1:0] count;
   // integer i;
    //constants
    assign value[0] = SYMBOL_SEPERATION >> 1;
    assign value[1] = - (SYMBOL_SEPERATION >> 1);
    assign value[2] = value[0] + SYMBOL_SEPERATION;
    assign value[3] = value[1] - SYMBOL_SEPERATION;
always_ff @ (posedge clk) begin
	if(!rstn) begin
        best_difference <= 'hFFFFFFFF;
        best_value <= 'b0;
        difference[0] <= 'b0;
        difference[1] <= 'b0;
        difference[2] <= 'b0;
        difference[3] <= 'b0;
        
    end
	else begin
        //calculate the difference:
        if(e_valid) begin
            difference[0] <= ((estimation - value[0]) >= 0) ? (estimation - value[0]) : ~(estimation - value[0]);
            difference[1] <= ((estimation - value[1]) >= 0) ? (estimation - value[1]) : ~(estimation - value[1]);
            difference[2] <= ((estimation - value[2]) >= 0) ? (estimation - value[2]) : ~(estimation - value[2]);
            difference[3] <= ((estimation - value[3]) >= 0) ? (estimation - value[3]) : ~(estimation - value[3]);
        end
    end
end

always_comb begin
       
    //really dumb way, can optimize later:
    if((difference[0] < difference[1]) && (difference[0] < difference[2]) && (difference[0] < difference[3])) begin
    feedback_value_i = value[0];
    f_valid = 1'b1;
    end
    else if((difference[1] < difference[0]) && (difference[1] < difference[2]) && (difference[1] < difference[3])) begin
    feedback_value_i = value[1];
    f_valid = 1'b1;
    end
    else if((difference[2] < difference[1]) && (difference[2] < difference[0]) &&(difference[2] < difference[3])) begin 
    feedback_value_i = value[2];
    f_valid = 1'b1;
    end
    else if((difference[3] < difference[1]) && (difference[3] < difference[2]) && (difference[3] < difference[0])) begin
    feedback_value_i = value[3];
    f_valid = 1'b1;
    end
    else begin
    feedback_value_i = 'b0;
    f_valid = 1'b0;
    end

    


end

endmodule