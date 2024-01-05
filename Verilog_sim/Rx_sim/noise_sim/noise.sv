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
        .rstn(rstn),
        .en(en),
        .data_out(random),
        .valid(random_valid));

//array to store comparison information
reg [63:0] possibilities[2:0];

initial begin
    possibilities[0] = 2 ** 63-1;
    possibilities[1] = (2 ** 63-1) + (2 ** 62);
    possibilities[2] = 2 ** 64 -1;
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        noise_out_valid <= 0;
        noise_out <= 8'b0;
    end
    else if (en) begin
        if (random < possibilities[0]) begin
            noise_out <= 8'b0;
            noise_out_valid <= 1'b1;
            $display("Condition 1: random=%h", random);
            $display("possibilities[0]: possibilities[0]=%h", possibilities[0]);
        end
        else if ((random >= possibilities[0]) && (random < possibilities[1])) begin
            noise_out <= 8'b1;
            noise_out_valid <= 1'b1;
            $display("Condition 2: random=%h", random);
            $display("possibilities[0]: possibilities[0]=%h", possibilities[0]);
            $display("possibilities[1]: possibilities[1]=%h", possibilities[1]);
        end
        else if ((random >= possibilities[1]) && (random < possibilities[2])) begin
            noise_out <= -8'b1;
            noise_out_valid <= 1'b1;
            $display("Condition 3: random=%h", random);
            $display("possibilities[0]: possibilities[0]=%h", possibilities[0]);
            $display("possibilities[1]: possibilities[1]=%h", possibilities[1]);
            $display("possibilities[2]: possibilities[2]=%h", possibilities[2]);
        end 
        else begin
            noise_out_valid <= 1'b0;
            $display("possibilities[0]: possibilities[0]=%h", possibilities[0]);
            $display("possibilities[1]: possibilities[1]=%h", possibilities[1]);
            $display("possibilities[2]: possibilities[2]=%h", possibilities[2]);
            $display("No Condition Matched: random=%h", random);
        end
    end
    else begin
        noise_out_valid <= 1'b0;
    end
end


endmodule