module noise_128_wrapper_mem (
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
    
    noise_128_mem noise_128_mem(
            .clk(clk),
            .en(en),
            .rstn(rstn),
            .noise_out(temp_i),
            .noise_counter(noise_counter),
            .noise_out_valid(simple_noise_out_valid)
        );
endmodule