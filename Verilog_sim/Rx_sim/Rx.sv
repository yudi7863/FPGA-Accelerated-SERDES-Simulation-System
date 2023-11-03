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
logic [PULSe_RESPONSE_LENGTH-1:0] shift_reg_b;
always _ff @ (posedge_clk) begin
	if(!rstn) begin
		//reset all the input signals
			signal_in <= 'b0;
			signal_in_valid <= 'b0;
	End
	Else begin
		//deconvolution, assuming that training is done
        //shift reg:
        if(signal_in_valid == 'b1){
            shift_reg_b <= shift_reg_a; //shift_reg_b takes in the old shift_reg_a value?
            shift_reg_a <= {shift_reg_a[PULSE_RESPONSE_LENGTH-2:0], signal_in[7]}; // not sure if this is the correct shifting 

        }
        //every cycle, we compute a new value:
        //we know the h value, so it backward:
        
		
	End
end
endmodule
