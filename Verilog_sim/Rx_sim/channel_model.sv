
//outputs the convolution of the input signal with a pulse response of arbitrary length
module ISI_channel#(
    //length of pulse response (UI) eg: if the pulse response is h = [1 0.5], PULSE_RESPONSE_LENGTH = 2
    parameter PULSE_RESPONSE_LENGTH = 2,
    //bit-resolution of output signal
    parameter SIGNAL_RESOLUTION = 8,
    //speration between symbols. eg: if SYMBOL seperation = 32, the pam-4 symbol set {0,1,2,3} should be mapped to {-48,-16,16,48}
    parameter SYMBOL_SEPERATION = 56)(
    input clk,
    input rstn,
    input signed [SIGNAL_RESOLUTION-1:0] signal_in,
    input signal_in_valid,
    output reg signed [SIGNAL_RESOLUTION-1:0] signal_out,
    output reg signal_out_valid =0);
       
    
    logic [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] convolution_result;
    logic [SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:0] isi_result;
    //shift register that shifts 8 bits of data 
    logic  [SIGNAL_RESOLUTION-1:0] shift_reg;

    /*initial begin
        isi_result = {({SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH{1'b0}})}; // Initialize to all zeros
        convolution_result = {({SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH{1'b0}})};
    end*/


    //take signal_in, multiply
    always @ (posedge clk) begin
        if (!rstn) begin
            signal_out_valid <= 0;
            isi_result <= {({SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH{1'b0}})}; // Initialize to all zeros
            convolution_result <= {({SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH{1'b0}})};
        end else begin
            if(signal_in_valid) begin
                //place the 1*signal_in in upper 8 bits, 0.5*signal_in in lower 8 bits
                convolution_result[SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:SIGNAL_RESOLUTION] <= signal_in;
                convolution_result[SIGNAL_RESOLUTION-1:0] <= signal_in >> 2; //divide by 2
                //add results to isi_results
                isi_result[SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:SIGNAL_RESOLUTION] <= isi_result[SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:SIGNAL_RESOLUTION]+convolution_result[SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:SIGNAL_RESOLUTION];
                isi_result[SIGNAL_RESOLUTION-1:0] <= isi_result[SIGNAL_RESOLUTION-1:0]+convolution_result[SIGNAL_RESOLUTION-1:0];
                //shift the upper 8 bits to output
                signal_out <= isi_result[SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:SIGNAL_RESOLUTION];
                shift_reg <= {isi_result[SIGNAL_RESOLUTION*PULSE_RESPONSE_LENGTH-1:SIGNAL_RESOLUTION], shift_reg[SIGNAL_RESOLUTION-1:0]};
                //enable signal_out_valid
                signal_out_valid <= 1;
            end else begin
                signal_out_valid <= 0;
            end

        end

    end

endmodule