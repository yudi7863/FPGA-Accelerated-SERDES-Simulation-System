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