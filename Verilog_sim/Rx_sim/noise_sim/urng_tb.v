`timescale 1ns / 1ps

module urng_tb;

reg clk;
reg en;
reg rstn;

wire [63:0] rand_out;
wire rand_out_valid;

urng urng_t(
        .clk(clk),
        .en(en),
        .rstn(rstn),
        .rand_out(rand_out),
        .rand_out_valid(rand_out_valid)
);
        
always #10 clk = ~clk;
    
initial begin
    #50 
    en <= 1;
    rstn <=1;
    #2120
    $display("Random Number:%h", rand_out);
    $finish;
end

endmodule