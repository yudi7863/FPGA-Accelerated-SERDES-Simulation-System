`timescale 1ns / 1ps
module noise_128_wrapper (
    input clk,
    input en,
    input rstn,
    input reg signed [7:0] noise_in,
    input noise_in_valid,
    output reg signed [7:0] noise_out,
    output reg [7:0] noise_counter[127:0],
    output reg noise_out_valid =0
);


    logic [7:0] temp;
    logic [7:0] temp_i;
    //logic [7:0] counter[127:0];
    logic simple_noise_out_valid;

   // assign noise_out = temp + noise_in;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            temp <= 'b0;
            noise_out <='b0;
            for(int i=0; i<128;i=i+1)begin
                noise_counter[i]<= 8'b0;     
            end
        end
        else begin
            temp <= temp_i;
            if(noise_in_valid && simple_noise_out_valid) begin
                noise_out <= temp_i+ noise_in;
                //noise_out <= temp_i + noise_in;
                noise_out_valid <= 'b1;
            end
            else begin
                noise_out <= noise_out;
                noise_out_valid <= 'b0;
            end
        end
    end
    
    noise_128 noise_128(
            .clk(clk),
            .en(en),
            .rstn(rstn),
            .noise_out(temp_i),
            .noise_counter(noise_counter),
            .noise_out_valid(simple_noise_out_valid)
        );
endmodule

module noise_128(
    input clk,
    input en,
    input rstn,
    output reg signed [7:0] noise_out,
    output reg [7:0] noise_counter[127:0],
    output reg noise_out_valid =0
);

wire [63:0] random;
wire random_valid;
reg gen_dut_start;

urng_64 dut (
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .start_control(gen_dut_start),
        .data_out(random),
        .valid(random_valid));

//array to store comparison information
reg [63:0] possibilities[127:0];
reg signed [7:0] noise_value[127:0];
//reg [7:0] noise_counter[127:0];
//for loop to initialize the array;


// initial begin//relative path:
//     //static string possibilities_file = "../../Matlab_sim/noise_prob//probability_verilog_helper.mem";
//     $readmemb("../../Matlab_sim/noise_prob//probability_verilog_helper.mem", possibilities);
// end

// initial begin
//     for(int i=0; i<128;i=i+1)begin
//         noise_value[i]=i-63;       
//         $display("noise value:%d",noise_value[i]); 
//         $display("possibility value:%d",possibilities[i]);
//     end
// end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        noise_out_valid <= 0;
        noise_out <= 8'b0;
        gen_dut_start <= 1'b0;
        for(int i=0; i<128;i=i+1)begin
            noise_counter[i]<= 8'b0;
            noise_value[i]=i-63;     
        end
        $readmemb("../../Matlab_sim/noise_prob//probability_verilog_helper_sigma(10).mem", possibilities);
    end
    else if (en) begin
        noise_out_valid <= 1'b0; // Default value
        gen_dut_start <= 1'b1;
        // if(random < possibilities[0])begin
        //     noise_out <=noise_value[0];
        // end
        // else if(random<possibilities[1]&&random>=possibilities[0])begin
        //     noise_out <=noise_value[1];
        // end
        // else if(random<possibilities[2]&&random>possibilities[0]&&random>=possibilities[1])begin
        //     noise_out <=noise_value[2];
        // end
        // else if(random<possibilities[3]&&random>possibilities[0]&&random>=possibilities[1]&&random>possibilities[2])begin
        //     noise_out <=noise_value[3];
        // end
        // Iterate through possibilities
        for (int i = 0; i < 128; i = i + 1) begin
            if (i==0)begin
                if (random < possibilities[i]) begin
                    noise_out <= noise_value[i] ; // Set noise_out based on the index
                     noise_counter[i]=noise_counter[i]+1;
                    noise_out_valid <= 1'b1;
                    //$display("initial random number:%d",random); 
                    //$display("initial possibility value:%d",possibilities[i]);
                end
            end
            else begin
                //if ((random >= possibilities[0]) && (random < possibilities[1]))
                if((random < possibilities[i])&&(random >= possibilities[i-1]))begin
                    noise_out = noise_value[i] ; // Set noise_out based on the index
                    noise_counter[i]=noise_counter[i]+1;
                    //$display("random = %d, possibilities[%0d] = %d,possibilities[%0d] = %d\n",random,i-1,possibilities[i-1],i,possibilities[i]); 
                    noise_out_valid <= 1'b1;
                end
            end
        end
    end
end

endmodule