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
reg signed [7:0] noise_value[127:0];
//for loop to initialize the array;

initial begin
    static string possibilities_file = "E:/fourth_year/ECE496/FPGA-Accelerated-SERDES-Simulation-System/Matlab_sim/Tx_sim/probability_verilog_helper.mem";
    // //open file for reading
    // static int fileID = $fopen(possibilities_file, "r");
    // if (fileID ==0) begin
    //     $display("Error: Could not open file '%s'", possibilities_file);
    //     $finish;
    // end

    // for(int i=0; i<128;i=i+1)begin
    //    if ($feof(fileID)) begin
    //         $display("Warning: Reached end of file before reading all values.");
    //         break;
    //     end

    //     $readmemb(possibilities_file, possibilities[i]);
    //     $display("possibility value:%d",possibilities[i]);
    // end
    $readmemb(possibilities_file, possibilities);
end

initial begin
    for(int i=0; i<128;i=i+1)begin
        noise_value[i]=i-63;       
        $display("noise value:%d",noise_value[i]); 
        $display("possibility value:%d",possibilities[i]);
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
            if (i==0)begin
                if (random < possibilities[i]) begin
                    noise_out <= noise_value[i] ; // Set noise_out based on the index
                    noise_out_valid <= 1'b1;
                end
            end
            else begin
                //if ((random >= possibilities[0]) && (random < possibilities[1]))
                if((random >= possibilities[i-1])&&(random < possibilities[i]))begin
                    noise_out <= noise_value[i] ; // Set noise_out based on the index
                    noise_out_valid <= 1'b1;
                end
            end
        end
    end
end

endmodule