module noise_128(
    input clk,
    input en,
    input rstn,
    output reg signed [7:0] noise_out,
    output reg noise_out_valid =0,
    //other sigs
    output logic done_wait,
    input [63:0] mem_data,
    input [7:0] location,
    input  load_mem
    //output reg [7:0] noise_counter[127:0]
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

//loading from mem:
integer i;
logic [7:0] j; //new index
logic [7:0] count;
logic [6:0] level [6:0];
logic [4:0] index [6:0];
logic [7:0] sel_0, sel_1, sel_2, sel_3, sel_4, sel_5, sel_6;
logic [6:0] middle_val [6:0];
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin 
        done_wait <= 'b0;
        i <= 'b0;
        count <= 'b0;
        
        level[6] <= 64;
        level[5] <= 32;
        level[4] <= 16;
        level[3] <= 8;
        level[2] <= 4;
        level[1] <= 2;
        level[0] <= 1;
        index[0] <= 6;
        index[1] <= 5;
        index[2] <= 4;
        index[3] <= 3;
        index[4] <= 2;
        index[5] <= 1;
        index[6] <= 0;
        for(int j=0; j<128;j=j+1)begin
            //noise_counter[i]<= 8'b0;
            noise_value[j]<=j-8'd63;     
        end
    end
    else begin
        if(load_mem) begin 
            i <= location;
            //need to make sure that i is a valid location...
            possibilities[i] <= mem_data;
            //possibilities[location] <= mem_data;
            count <= count + 'b1;
        end
        if(count == 'd129) begin //two cycles late...
            //load_mem <= 'b0; this needs to be controlled outside..
            done_wait = 'b1;
        end
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        noise_out_valid <= 0;
        noise_out <= 8'b0;
        sel_0 <='b0;
        sel_1 <='b0;
        sel_2 <='b0;
        sel_3 <='b0;
        sel_4 <='b0;
        sel_5 <='b0;
        sel_6 <='b0;
        j <= 'b0;
    end
    else if (en && !load_mem && done_wait) begin
        noise_out_valid <= 1'b0; // Default value
        gen_dut_start <= 1'b1;
      //  sel = 'b0;
        // Iterate through possibilities
        
        
        
     /*   for (int i = 0; i < 128; i = i + 1) begin
            if (i==0)begin
                if (random < possibilities[i]) begin
                    noise_out <= noise_value[i] ; // Set noise_out based on the index
                    noise_out_valid <= 1'b1;
                    noise_counter[i]=noise_counter[i]+1;
                end
            end
            else begin
                //if ((random >= possibilities[0]) && (random < possibilities[1]))
                if((random < possibilities[i])&&(random >= possibilities[i-1]))begin
                    noise_out <= noise_value[i] ; // Set noise_out based on the index
                    noise_out_valid <= 1'b1;
                    noise_counter[i]=noise_counter[i]+1;
                end
            end
        end*/
      // Variables to keep track of the boundaries of the search

    // Binary search algorithm
    if(j < 7) begin
        //first level:
        middle_val[0] <= {7{sel_0[0]}}&level[0] + {7{sel_0[1]}}&level[1] + {7{sel_0[2]}}&level[2]  + {7{sel_0[3]}}&level[3] +{7{sel_0[4]}}&level[4] +{7{sel_0[5]}}&level[5] +{7{sel_0[6]}}&level[6]; //middle_val[0] will be ready after 7 clk cycles
          //sel[0] * level[0] + sel[1] * level[1] + sel[2] * level[2] + sel[3] * level[3] + sel[4] * level[4] + sel[5] * level[5] + sel[6] * level[6];  
        middle_val[0] <= level[j] + middle_val[0];
        if(random >= possibilities[middle_val[0]-1]) begin
            sel_0[6-j] <= 1'b1;
        end
        else begin
            sel_0[6-j] <= 1'b0;
        end
    end
    if(j >= 1 && j < 8) begin
                //second level:
        middle_val[1] <= {7{sel_1[0]}}&level[0] + {7{sel_1[1]}}&level[1] + {7{sel_1[2]}}&level[2]  + {7{sel_1[3]}}&level[3] +{7{sel_1[4]}}&level[4] +{7{sel_1[5]}}&level[5] +{7{sel_1[6]}}&level[6]; //middle_val[0] will be ready after 7 clk cycles
          //sel[0] * level[0] + sel[1] * level[1] + sel[2] * level[2] + sel[3] * level[3] + sel[4] * level[4] + sel[5] * level[5] + sel[6] * level[6];  
        middle_val[1] <= level[j-1] + middle_val[1];
        if(random >= possibilities[middle_val[1]-1]) begin
            sel_1[6-(j-1)] <= 1'b1;
        end
        else begin
            sel_1[6-(j-1)] <= 1'b0;
        end
    end
    if(j >= 2 && j < 9) begin
                //second level:
        middle_val[2] <= {7{sel_2[0]}}&level[0] + {7{sel_2[1]}}&level[1] + {7{sel_2[2]}}&level[2]  + {7{sel_2[3]}}&level[3] +{7{sel_2[4]}}&level[4] +{7{sel_2[5]}}&level[5] +{7{sel_2[6]}}&level[6]; //middle_val[0] will be ready after 7 clk cycles
          //sel[0] * level[0] + sel[1] * level[1] + sel[2] * level[2] + sel[3] * level[3] + sel[4] * level[4] + sel[5] * level[5] + sel[6] * level[6];  
        middle_val[2] <= level[j-2] + middle_val[2];
        if(random >= possibilities[middle_val[2]-1]) begin
            sel_2[6-(j-2)] <= 1'b1;
        end
        else begin
            sel_2[6-(j-2)] <= 1'b0;
        end
    end
    if(j >= 3 && j < 10) begin
                //second level:
        middle_val[3] <= {7{sel_3[0]}}&level[0] + {7{sel_3[1]}}&level[1] + {7{sel_3[2]}}&level[2]  + {7{sel_3[3]}}&level[3] +{7{sel_3[4]}}&level[4] +{7{sel_3[5]}}&level[5] +{7{sel_3[6]}}&level[6]; //middle_val[0] will be ready after 7 clk cycles
          //sel[0] * level[0] + sel[1] * level[1] + sel[2] * level[2] + sel[3] * level[3] + sel[4] * level[4] + sel[5] * level[5] + sel[6] * level[6];  
        middle_val[3] <= level[j-3] + middle_val[1];
        if(random >= possibilities[middle_val[1]-1]) begin
            sel_3[6-(j-3)] <= 1'b1;
        end
        else begin
            sel_3[6-(j-3)] <= 1'b0;
        end
    end
    j <= j + 1'b1;
    //this needs to be pipelined
    noise_out <= noise_value[sel_0];
    noise_out_valid <= 1'b1;
    end
end

endmodule