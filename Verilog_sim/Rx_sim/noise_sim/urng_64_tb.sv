`timescale 1ns / 1ps


module urng_64_tb;
    
    reg clk = 0;
    reg en = 0;
    reg rstn = 0;
    
    wire [63:0] random;
    wire random_valid;

    urng_64 dut (
        .clk(clk),
        .en(en),
        .rstn(rstn),
        .data_out(random),
        .valid(random_valid));
        
    always #10 clk = ~clk;
    
    initial begin
        #50
        rstn <=1;
        en<=1;
        #2120
        
        $finish;
    end

endmodule