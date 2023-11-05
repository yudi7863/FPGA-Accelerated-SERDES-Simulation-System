//assumptions: I know about the h functions and I know about the length of the h functions
Module Deconvolution #(
Parameter PULSE_RESPONSE_LENGTH = 2,
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
logic [7:0] h_function_vals [PULSE_RESPONSE_LENGTH-1:0];
//for now assume PULSE_RESPONSE_LENGTH = 2
assign h_function_vals[0] = 'h1;
assign h_function_vals[1] = 'h1 >> 1; //questional here, need to verify
//shift register:
logic [PULSE_RESPONSE_LENGTH-1:0] shift_reg_a;
logic [PULSE_RESPONSE_LENGTH-1:0] shift_reg_b;
logic [PULSE_RESPONSE_LENGTH-1:0] intermediate;
always _ff @ (posedge_clk) begin
	if(!rstn) begin
		//reset all the input signals
			signal_in <= 'b0;
			signal_in_valid <= 'b0;
    end
	else begin
		//deconvolution, assuming that training is done
        //shift reg:
        //need synchronization between signal_out and signal_in here:

        if(signal_in_valid == 'b1){
            shift_reg_b <= shift_reg_a; //shift_reg_b takes in the old shift_reg_a value?
            shift_reg_a <= {shift_reg_a[PULSE_RESPONSE_LENGTH-2:0], signal_in[PULSE_RESPONSE_LENGTH-1]}; // not sure if this is the correct shifting 

        }
        //every cycle, we compute a new value:
        //we know the h value, so it backward:
        //y_1 = h_0x_2 + h_1X_1 + n2
        //(y_1 - h_1x_0) = h_0x_1 + n_1
        //assume that the previous signal out was valid:
        intermediate <= signal_out[0] - signal_in[PULSE_RESPONSE_LENGTH-1];
        signal_out <= intermediate << h_function_vals[1]; //something like this

		
    end
end
endmodule
