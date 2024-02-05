module noise_128_tb;
    //testing 128 noise with the control signals for now:

    //connect to wrapper, with control signals to take in data:
    //control signals for noise_wrapper:

    //signals:
    logic clk;
    logic en;
    logic rstn;
    logic signed [7:0] noise_in;
    logic noise_in_valid;
    logic signed [7:0] noise_out;
    logic noise_out_valid;
    //other:
    logic done_wait;
    logic [63:0] mem_data;
    logic [7:0] location;
    logic  load_mem;
    //clk:
    always #10 clk = ~clk;


    // mimicking the memory to control location and mem_data:
    



    //dut:
    noise_128_wrapper dut(
        .clk (clk),
        .en(en),
        .rstn(rstn),
        .noise_in(noise_in),
        .noise_out(noise_out),
        .noise_out_valid(nvalid),
        .done_wait(done_wait),
        .mem_data(mem_data),
        .location(location),
        .load_mem(load_mem)
    )
    initial begin
        clk <= 'b0;
        rstn <= 'b0;
        //control signals first
    

    end

                                
endmodule