`timescale 1ns / 1ps

module noise_tb;
    reg clk = 0;
    reg en = 0;
    reg rstn = 0;

    wire [7:0] noise;
    wire noise_valid;

    noise simple_noise(
        .clk(clk),
        .en(en),
        .rstn(rstn),
        .noise_out(noise),
        .noise_out_valid(noise_valid)
    );

    always #10 clk = ~clk;
    
    initial begin
        #50
        rstn <=1;
        en<=1;
        #2120
        
        $finish;
    end


endmodule