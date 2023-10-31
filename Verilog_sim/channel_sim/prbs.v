//generates pseudo-random-binary-sequence of length 2^31-1 
module prbs31 #(parameter SEED = 31'b1101000101011010010010100011111)(
    input clk,
    input en,
    input rstn,
    output reg data_out,
    output reg data_out_valid = 0);
    
    reg [30:0] sr = SEED;
    wire sr_in;
    
    assign sr_in = (sr[30]^sr[27]);
    
    always @ (posedge clk)
    if (!rstn) begin
        sr = SEED;
        data_out_valid = 0;
    end else begin
        if (en) begin
            sr <= {sr[29:0],sr_in};
            data_out <=  sr_in;
            data_out_valid <= 1;
        end else begin
	    data_out_valid <=0;	
	end
    end
endmodule

//checks for errors in pseudo-random-binary-sequence of length 2^31-1 
module prbs31_checker #(parameter SEED = 31'b1101000101011010010010100011111)(
    input clk,
    input rstn,
    input data_in,
    input data_in_valid,

    output reg [31:0] total_bits = 0,
    output reg [31:0] total_bit_errors = 0);
    
    reg [30:0] sr = SEED;
    wire sr_in;
    
    assign sr_in = (sr[30]^sr[27]);
    
    always @ (posedge clk)
    if (!rstn) begin
        sr = SEED;
        total_bits =0;
        total_bit_errors = 0;
    end else begin
        if (data_in_valid) begin
            sr <= {sr[29:0],sr_in};
            if (data_in == sr_in) begin
                total_bits <= total_bits + 1;
            end else begin
                total_bits <= total_bits + 1;
                total_bit_errors <= total_bit_errors + 1;
            end
        end
    end
endmodule
