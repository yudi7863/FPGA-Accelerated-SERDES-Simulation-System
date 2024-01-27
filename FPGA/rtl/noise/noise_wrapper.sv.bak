module noise_wrapper (
    input clk,
    input en,
    input rstn,
    input reg signed [7:0] noise_in,
    output reg signed [7:0] noise_out,
    output reg noise_out_valid =0
);

    logic [7:0] temp;
    logic [7:0] temp_i;
   // assign noise_out = temp + noise_in;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            temp <= 'b0;
        end
        temp <= temp_i;
        noise_out <= temp_i + noise_in*28;
    end
    
    noise simple_noise(
            .clk(clk),
            .en(en),
            .rstn(rstn),
            .noise_out(temp_i),
            .noise_out_valid(noise_out_valid)
        );

endmodule
