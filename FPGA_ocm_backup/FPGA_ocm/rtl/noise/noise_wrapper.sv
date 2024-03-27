module noise_128_wrapper (
    input clk,
    input en,
    input rstn,
    input reg signed [7:0] noise_in,
    input noise_in_valid,
    output reg signed [7:0] noise_out,
    //output reg [7:0] noise_counter[127:0],
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
            /*for(int i=0; i<128;i=i+1)begin
                noise_counter[i]<= 8'b0;     
            end*/
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
            .load_mem(load_mem),
            //.noise_counter(noise_counter)
        );
endmodule