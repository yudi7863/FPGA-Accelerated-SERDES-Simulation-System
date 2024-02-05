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
logic [63:0] possibilities[127:0];
logic signed [7:0] noise_value[127:0];
//for loop to initialize the array;

initial begin//relative path:
    //static string possibilities_file = "./rtl/noise_prob/probability_verilog_helper.mem";
    $readmemb("./rtl/noise_prob/probability_verilog_helper.mem", possibilities);
end

initial begin
    for(int i=0; i<128;i=i+1)begin
        noise_value[i]=i-63;       
        //$display("noise value:%d",noise_value[i]); 
        //$display("possibility value:%d",possibilities[i]);
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