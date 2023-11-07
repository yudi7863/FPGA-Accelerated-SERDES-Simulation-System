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
output reg signal_out_valid);

//assuming values for h function:2 d array
logic [PULSE_RESPONSE_LENGTH-1:0] h_function_vals [7:0];
//for now assume PULSE_RESPONSE_LENGTH = 2
assign h_function_vals[0] = 'h1;
assign h_function_vals[1] = 'h1 >> 1; //questional here, need to verify
//shift register:
logic  [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] feedback_value;
logic [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] subtract_result;
logic [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] estimation;

decision_maker DM (
    .clk(clk), 
    .rstn(rstn), 
    .estimation(estimation), 
    .feedback_value(feedback_value),
    .e_valid(signal_in_valid),
    .f_valid(signal_out_valid)
    );

always_ff @ (posedge clk) begin
	if(!rstn) begin
		//reset all the output signals
			signal_out <= 'b0;
			signal_out_valid <= 'b0;
    end
	else begin
        if(signal_in_valid == 'b1) begin
            subtract_result <= signal_in - feedback_value;
            estimation <= subtract_result/h_function_vals[0]; //currently h0_1 = 1, which does nothing
            signal_out <= feedback_value;
        end
    end
end
endmodule

module decision_maker #(
    parameter SIGNAL_RESOLUTION = 8,
    parameter SYMBOL_SEPERATION = 56) 
(   input clk,
    input rstn,
    input [SIGNAL_RESOLUTION-1:0] estimation, 
    input e_valid,
    output logic [SIGNAL_RESOLUTION-1:0] feedback_value,
    output logic f_valid);
    //the four values that we want
    logic [SIGNAL_RESOLUTION-1:0] value [3:0];
    logic [SIGNAL_RESOLUTION-1:0] difference [3:0];
    logic [SIGNAL_RESOLUTION-1:0] best_value;
    logic [SIGNAL_RESOLUTION-1:0] best_difference;
    //logic [1:0] count;
   // integer i;
    //constants
    assign value[0] = SYMBOL_SEPERATION >> 1;
    assign value[1] = - (SYMBOL_SEPERATION >> 1);
    assign value[2] = value[0] + SYMBOL_SEPERATION;
    assign value[3] = value[1] - SYMBOL_SEPERATION;
always_ff @ (posedge clk) begin
	if(!rstn) begin
		//reset all the output signals
		feedback_value <= 'b0;
        best_difference <= 'hFFFFFFFF;
        best_value <= 'b0;
        //count <= 'b0;
    end
	else begin
        //calculate the difference:
        if(e_valid)begin
            difference[0] <= estimation-value[0];
            difference[1] <= estimation-value[1];
            difference[2] <= estimation-value[2];
            difference[3] <= estimation-value[3];

            if(difference[0][SIGNAL_RESOLUTION-1] == 1'b1) difference[0] = ~difference[0];
            if(difference[1][SIGNAL_RESOLUTION-1] == 1'b1) difference[1] = ~difference[1];
            if(difference[2][SIGNAL_RESOLUTION-1] == 1'b1) difference[2] = ~difference[2];
            if(difference[3][SIGNAL_RESOLUTION-1] == 1'b1)  difference[3] = ~difference[3];
            //making the decision

             //really dumb way, can optimize later:
             if(difference[0] < difference[1] && difference[0] < difference[2] && difference[0] < difference[3]) begin
                feedback_value <= value[0];
                f_valid <= 1'b1;
             end
             if(difference[1] < difference[0] && difference[1] < difference[2] && difference[1] < difference[3]) begin
                feedback_value <= value[1];
                f_valid <= 1'b1;
             end
             if(difference[2] < difference[1] && difference[2] < difference[0] && difference[2] < difference[3]) begin 
                feedback_value <= value[2];
                f_valid <= 1'b1;
             end
             if(difference[3] < difference[1] && difference[3] < difference[2] && difference[3] < difference[0]) begin
                feedback_value <= value[3];
                f_valid <= 1'b1;
             end
        end
    end
end

endmodule
