`timescale 1ns / 1ps

module urng#(parameter integer A =64'd6364136223846793005,
parameter integer C= 64'd1442695040888963407,
parameter integer M= 64'd9223372036854775808)(
    input clk,
    input en,
    input rstn,
    output reg [63:0] rand_out,
    output reg rand_out_valid = 0
);

// Parameters for the LCG algorithm
// Modulus (2^63)

// Internal state register
//reg [63:0] state;

// Always block for generating random numbers on each clock edge
always @(posedge clk) begin
    if (!rstn) begin
        // Reset state on reset signal
        rand_out_valid <=0;
        rand_out <= 64'h123456789ABCDEF0; // Initial seed value
    end else begin
        // Update state using LCG algorithm
        if(en)begin
            rand_out <= (A * rand_out + C) % M;
            rand_out_valid <=1;
        end else begin
            rand_out_valid <=0;
        end
    end
end

// Output the random number
//assign rand_out = state;

endmodule