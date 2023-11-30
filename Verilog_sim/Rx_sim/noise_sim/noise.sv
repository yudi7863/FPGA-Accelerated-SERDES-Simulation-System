`timescale 1ns / 1ps

module noise(
    input clk,
    input en,
    input rstn,
    output reg signed [7:0] noise_out,
    output reg noise_out_valid =0
);
//64 bit uniform random number generator
//generate a random number and compare
wire [63:0] random;
wire random_valid;

urng_64 dut (
        .clk(clk),
        .en(en),
        .rstn(rstn),
        .data_out(random),
        .valid(random_valid));

//array to store comparison information
logic [63:0] possibilities[2:0];
assign possibilities[0]=1 << 64 >> 1;
assign possibilities[1]=(1 << 64 >> 1) + (1 << 64 >> 2);
assign possibilities[2]=1 << 64;

always @ (posedge clk) begin
    if (!rstn) begin
        noise_out_valid <=0;
        noise_out <= 8'b0;
    end
    else
        if (random < possibilities[0]) begin
            noise_out <= 0;
            noise_out_valid <= 1'b1;
        end
        else if ((random >= possibilities[0]) && (random < possibilities[1])) begin
            noise_out <= 1;
            noise_out_valid <= 1'b1;
        end
        else if ((random >= possibilities[1]) && (random < possibilities[2])) begin
            noise_out <= -1;
            noise_out_valid <= 1'b1;
        end 
        else begin
            noise_out_valid <= 1'b0;
        end
        

end

endmodule