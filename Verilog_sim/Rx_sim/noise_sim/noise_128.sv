`timescale 1ns / 1ps

module noise_128(
    input clk,
    input en,
    input rstn,
    output reg signed [7:0] noise_out,
    output reg noise_out_valid =0
);

wire [63:0] random;
wire random_valid;

urng_64 dut (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .data_out(random),
        .valid(random_valid));

//array to store comparison information
reg [63:0] possibilities[127:0];

//for loop to initialize the array;
initial begin
    for(int i=0; i<128;i++)begin
        if (i==0)begin
            possibilities[i]= i >> 2 * (2**64-1);
        end
        else begin
            possibilities[i]= i >> 2 * (2**64-1) + possibilities[i-1];
        end
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        noise_out_valid <= 0;
        noise_out <= 8'b0;
    end
    else if (en) begin
        noise_out_valid <= 1'b0; // Default value

        // Iterate through possibilities
        for (int i = 0; i < 128; i = i + 1) begin
        if (random < possibilities[i]) begin
            noise_out <=  ; // Set noise_out based on the index
            noise_out_valid <= 1'b1;
            // You can add additional actions here if needed
        end
        end
    end
end

endmodule