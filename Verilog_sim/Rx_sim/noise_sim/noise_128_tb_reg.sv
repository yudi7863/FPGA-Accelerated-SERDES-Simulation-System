`timescale 1ns / 1ps

module noise_128_tb_reg;
    reg clk = 0;
    reg en = 0;
    reg rstn = 0;

    wire [7:0] noise;
    wire noise_valid;

    noise_128 noise_128(
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
        //$display("\nBits Transmitted:%d", total_bits);
        $display("Noise out:%d",noise);
        $finish;
    end


endmodule