`timescale 1ns / 1ps
module noise_128_wrapper #(
    parameter PULSE_RESPONSE_LENGTH,
    parameter SIGNAL_RESOLUTION,
    parameter SYMBOL_SEPERATION)(
    input clk,
    input en,
    input rstn,
    input reg signed [SIGNAL_RESOLUTION-1:0] noise_in,
    input noise_in_valid,
    output reg signed [SIGNAL_RESOLUTION-1:0] noise_out,
    output reg [7:0] noise_counter[127:0],
    output reg noise_out_valid =0
);


    logic [7:0] temp;
    logic signed [7:0] temp_i;
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

logic [6:0] level [6:0];
logic [7:0] sel;
logic [7:0] sel_debug;
logic [6:0] middle_val [6:0];
logic [63:0] random_num [6:0];

logic [7:0] sel1;
logic [7:0] sel2;
logic [7:0] sel3;
logic [7:0] sel4;
logic [7:0] sel5;
logic [7:0] sel6;

logic debug;

//assign middle_val[6] = sel6[0] * level[0] + sel6[1] * level[1] + sel6[2] * level[2] + sel6[3] * level[3] + sel6[4] * level[4] + sel6[5] * level[5] + sel6[6] * level[6] + level[6];
//assign middle_val[5] = sel5[0] * level[0] + sel5[1] * level[1] + sel5[2] * level[2] + sel5[3] * level[3] + sel5[4] * level[4] + sel5[5] * level[5] + sel5[6] * level[6] + level[5];  
//assign middle_val[4] = sel4[0] * level[0] + sel4[1] * level[1] + sel4[2] * level[2] + sel4[3] * level[3] + sel4[4] * level[4] + sel4[5] * level[5] + sel4[6] * level[6] + level[4];  
//assign middle_val[3] = sel3[0] * level[0] + sel3[1] * level[1] + sel3[2] * level[2] + sel3[3] * level[3] + sel3[4] * level[4] + sel3[5] * level[5] + sel3[6] * level[6] + level[3];  
//assign middle_val[2] = sel2[0] * level[0] + sel2[1] * level[1] + sel2[2] * level[2] + sel2[3] * level[3] + sel2[4] * level[4] + sel2[5] * level[5] + sel2[6] * level[6] + level[2];  
//assign middle_val[1] = sel1[0] * level[0] + sel1[1] * level[1] + sel1[2] * level[2] + sel1[3] * level[3] + sel1[4] * level[4] + sel1[5] * level[5] + sel1[6] * level[6] + level[1];  
//assign middle_val[0] = sel[0] * level[0] + sel[1] * level[1] + sel[2] * level[2] + sel[3] * level[3] + sel[4] * level[4] + sel[5] * level[5] + sel[6] * level[6] + level[0];

assign middle_val[6] = sel6|level[6];
assign middle_val[5] = sel5|level[5];  
assign middle_val[4] = sel4|level[4];  
assign middle_val[3] = sel3|level[3];  
assign middle_val[2] = sel2|level[2];  
assign middle_val[1] = sel1|level[1];  
assign middle_val[0] = sel|level[0];

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        noise_out_valid <= 0;
        noise_out <= 8'b0;
        gen_dut_start <= 1'b0;
        for(int i=0; i<128;i=i+1)begin
            noise_counter[i]<= 8'b0;
            noise_value[i]=i-63;     
        end
        level[6] <= 64;
        level[5] <= 32;
        level[4] <= 16;
        level[3] <= 8;
        level[2] <= 4;
        level[1] <= 2;
        level[0] <= 1;

        sel <='b0;
        sel1 <='b0;
        sel2 <='b0;
        sel3 <='b0;
        sel4 <='b0;
        sel5 <='b0;
        sel6 <='b0;        
        for (int i = 0; i < 7; i++)begin
            random_num[i] <='b0;
        end
        sel_debug <='b0;
        debug <= 'b0;
        //$readmemb("../../Matlab_sim/noise_prob//probability_verilog_helper_sigma(10).mem", possibilities);
        $readmemb("../../Matlab_sim/Tx_sim/probability_verilog_helper.mem", possibilities);
    end
    else if (en) begin
        gen_dut_start <= 1'b1;
        if(debug == 'b0) begin
            if(random_num[6] >= possibilities[63]) begin
                sel6[6] <= 1'b1;
            end
            else begin
                sel6[6] <= 1'b0;
            end

            if(random_num[5] >= possibilities[middle_val[5]-1]) begin
                sel5[5] <= 1'b1;
            end
            else begin
                sel5[5] <= 1'b0;
            end
 
            if(random_num[4] >= possibilities[middle_val[4]-1]) begin
                sel4[4] <= 1'b1;
            end
            else begin
                sel4[4] <= 1'b0;
            end

            if(random_num[3] >= possibilities[middle_val[3]-1]) begin
                sel3[3] <= 1'b1;
            end
            else begin
                sel3[3] <= 1'b0;
            end

            if(random_num[2] >= possibilities[middle_val[2]-1]) begin
                sel2[2] <= 1'b1;
            end
            else begin
                sel2[2] <= 1'b0;
            end

            if(random_num[1] >= possibilities[middle_val[1]-1]) begin
                sel1[1] <= 1'b1;
            end
            else begin
                sel1[1] <= 1'b0;
            end

            if(random_num[0] >= possibilities[middle_val[0]-1]) begin
                sel[0] <= 1'b1;
            end
            else begin
                sel[0] <= 1'b0;
            end
            debug = 'b1;        
        end
        else begin
            noise_out <= noise_value[sel];
            noise_out_valid <= 1'b1;
            
            random_num[6] <= random;
            random_num[5] <= random_num[6];
            random_num[4] <= random_num[5];
            random_num[3] <= random_num[4];
            random_num[2] <= random_num[3];
            random_num[1] <= random_num[2];
            random_num[0] <= random_num[1];

            sel6 <= 'b0;
            sel5 <= sel6;
            sel4 <= sel5;
            sel3 <= sel4;
            sel2 <= sel3;
            sel1 <= sel2;
            sel <= sel1;

            debug = 'b0;
        end        
    end
end
endmodule