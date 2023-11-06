//assumptions: I know about the h functions and I know about the length of the h functions
Module DFE #(
parameter PULSE_RESPONSE_LENGTH = 2,
parameter SIGNAL_RESOLUTION = 8,
parameter SYMBOL_SEPERATION = 56) {
input clk,
input rstn,
input signed [SIGNAL_RESOLUTION-1:0] signal_in,
input signal_in_valid,

input [7:0] noise, //not sure what length to set for this one
input signed [SIGNAL_RESOLUTION-1:0] train_data,
input train_data_valid,

output reg signed [SIGNAL_RESOLUTION-1:0] signal_out,
output reg signal_out_valid};

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
    .feedback_value(feedback_value)
    );

always_ff @ (posedge clk) begin
	if(!rstn) begin
		//reset all the output signals
			signal_out <= 'b0;
			signal_out_valid <= 'b0;
    end
	else begin
        if(signal_in_valid == 'b1){
            subtract_result <= signal_in - feedback_value;
            estimation <= subtract_result; //currently h0_1 = 1, which does nothing
        }
    end
end
endmodule

module decision_maker #(
    parameter SIGNAL_RESOLUTION = 8,
    parameter SYMBOL_SEPERATION = 56) 
{   input clk,
    input rstn,
    input [SIGNAL_RESOLUTION-1:0] estimation, 
    input e_valid,
    output [SIGNAL_RESOLUTION-1:0] feedback_value,
    output f_valid};
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
    assign value[2] = SYMBOL_SEPERATION >> 1 + SYMBOL_SEPARATION;
    assign value[3] = - (SYMBOL_SEPERATION >> 1 + SYMBOL_SEPARATION);
always_ff @ (posedge clk) begin
	if(!rstn) begin
		//reset all the output signals
		feedback_value <= 'b0;
        best_difference <= 'hFFFFFFFF;
        best_value <= 'b0;
        count <= 'b0;
    end
	else begin
        //calculate the difference:
        if(e_valid)begin
            differece[0] <= estimation-value[0];
            differece[1] <= estimation-value[1];
            differece[2] <= estimation-value[2];
            differece[3] <= estimation-value[3];

            if(differece[0][SIGNAL_RESOLUTION-1] == 1'b1) difference[0] = ~differece[0];
            if(differece[1][SIGNAL_RESOLUTION-1] == 1'b1) differece[1] = ~differece[1];
            if(differece[2][SIGNAL_RESOLUTION-1] == 1'b1) differece[2] = ~differece[2];
            if(differece[3][SIGNAL_RESOLUTION-1] == 1'b1)  differece[3] = ~differece[3];
            //making the decision
            /*for(i = 0; i < 4; i++)begin
                if(difference[i] < best_difference) begin
                    best_difference <= difference[i];
                    best_value <= value[i];
                    count <= count + 'b1;
                end
            end
            if(count == 'b11) begin
                f_valid <= 'b1;
                feedback_value <= 
            end*/

             //really dumb way, can optimize later:
             if(difference[0] < difference[1] && difference[0] < difference[2] && difference[0] < difference[3]) feedback_value <= value[0];
             if(difference[1] < difference[0] && difference[1] < difference[2] && difference[1] < difference[3]) feedback_value <= value[1];
             if(difference[2] < difference[1] && difference[2] < difference[0] && difference[2] < difference[3]) feedback_value <= value[2];
             if(difference[3] < difference[1] && difference[3] < difference[2] && difference[3] < difference[0]) feedback_value <= value[3];
        end
    end
end

endmodule
