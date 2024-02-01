//assumptions: I know about the h functions and I know about the length of the h functions
module DFE #(
parameter PULSE_RESPONSE_LENGTH = 2,
parameter SIGNAL_RESOLUTION = 8,
parameter SYMBOL_SEPERATION = 56) (
input clk,
input rstn,
input signed [SIGNAL_RESOLUTION-1:0] signal_in,
input signal_in_valid,

input [7:0] noise, //not sure what length to set for this one
input signed [SIGNAL_RESOLUTION-1:0] train_data,
input train_data_valid,

output reg signed [SIGNAL_RESOLUTION-1:0] signal_out,
output logic signal_out_valid);

//assuming values for h function:2 d array
logic [PULSE_RESPONSE_LENGTH-1:0] h_function_vals [7:0];
//for now assume PULSE_RESPONSE_LENGTH = 2
assign h_function_vals[0] = 'h1;
assign h_function_vals[1] = 'h1; //how to represent this lol
//shift register:
logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] feedback_value;
logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] division;
logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] subtract_result;
logic signed [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] buffer;
logic f_valid;
assign signal_out = buffer;
logic e_valid;
logic temp;
decision_maker DM (
    .clk(clk), 
    .rstn(rstn), 
    .estimation(subtract_result),//estimation), 
    .feedback_value(feedback_value),
    .e_valid(e_valid),
    .f_valid(f_valid)
    );

always_ff @ (posedge clk) begin
	if(!rstn) begin
			e_valid <= 'b0;
            division <='b0;
            subtract_result <='b0;
            signal_out_valid <= 'b0;
            buffer <= 'b0;
    end
	else begin
        if(signal_in_valid == 'b1) begin
            //estimation <= subtract_result; //currently h0_1 = 1, which does nothing
            buffer <= feedback_value;
            subtract_result <= signal_in - (feedback_value >>> h_function_vals[1]);
            e_valid <= 'b1;
        end
        else begin 
            e_valid <='b0;
        end
        if(f_valid == 'b1) begin
            signal_out_valid <= ~signal_out_valid;
        end
       
    end
end
endmodule

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
    f_valid = 1'b0;
    end

    


end

endmodule
