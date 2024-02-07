module noise_128_wrapper (
    input clk,
    input en,
    input rstn,
    input reg signed [7:0] noise_in,
    input noise_in_valid,
    output reg signed [7:0] noise_out,
    output reg noise_out_valid =0,
    //other:
    output logic done_wait,
    input [63:0] mem_data,
    input [7:0] location,
    input  load_mem

);

    logic [7:0] temp;
    logic [7:0] temp_i;
    logic simple_noise_out_valid;
   // assign noise_out = temp + noise_in;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            temp <= 'b0;
            noise_out <='b0;
        end
        else begin
            temp <= temp_i;
            if(noise_in_valid && simple_noise_out_valid && !load_mem && done_wait) begin
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
            .noise_out_valid(simple_noise_out_valid),
            .done_wait(done_wait),
            .mem_data(mem_data),
            .location(location),
            .load_mem(load_mem)
        );
endmodule

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

/* initial begin//relative path:
    //static string possibilities_file = "../../Matlab_sim/noise_prob//probability_verilog_helper.mem";
    $readmemb("../../Matlab_sim/noise_prob//probability_verilog_helper.mem", possibilities);
end
*/
initial begin
    for(int i=0; i<128;i=i+1)begin
        noise_value[i]=i-63;       
        $display("noise value:%d",noise_value[i]); 
        $display("possibility value:%d",possibilities[i]);
    end
end 
//loading from mem:
integer i;
logic [7:0] count;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin 
        done_wait <= 'b0;
        i <= 'b0;
        count <= 'b0;
    end
    else begin
        if(load_mem) begin 
            i <= location;
            //need to make sure that i is a valid location...
            possibilities[i] <= mem_data;
            count <= count + 'b1;
        end
        if(count == 'd127) begin
            //load_mem <= 'b0; this needs to be controlled outside..
            done_wait = 'b1;
        end
    end
end

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        noise_out_valid <= 0;
        noise_out <= 8'b0;
    end
    else if (en && !load_mem && done_wait) begin
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