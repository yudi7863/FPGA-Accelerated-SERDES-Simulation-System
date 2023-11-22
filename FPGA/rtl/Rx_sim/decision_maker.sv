module decision_maker #(
    parameter PULSE_RESPONSE_LENGTH = 2,
    parameter SIGNAL_RESOLUTION = 8,
    parameter SYMBOL_SEPERATION = 56) 
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
    f_valid = 'b0;
    end
    


end

endmodule