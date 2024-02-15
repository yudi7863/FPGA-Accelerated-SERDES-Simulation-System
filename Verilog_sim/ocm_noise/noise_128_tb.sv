`timescale 1ns / 1ps
module noise_128_tb;
    //testing 128 noise with the control signals for now:

    //connect to wrapper, with control signals to take in data:
    //control signals for noise_wrapper:

    //signals:
    logic clk;
    logic en;
    logic rstn;
    logic signed [7:0] noise_in;
    logic nvalid;
    logic valid;
    logic signed [7:0] noise_out;
    //other:
    logic done_wait;
    logic [63:0] mem_data;
    logic [7:0] location;
    logic  load_mem;
    //clk:
    always #10 clk = ~clk;


    // mimicking the memory to control location and mem_data:
    logic [63:0] set_data[14:0];
    assign set_data[0] = 'h111111111111111;
    assign set_data[1] = 'h222222222222222;
    assign set_data[2] = 'h3333333333333333;
    assign set_data[3] = 'h4444444444444444;
    assign set_data[4] = 'h5555555555555555;
    assign set_data[5] = 'h6666666666666666;
    assign set_data[6] = 'h7777777777777777;
    assign set_data[7] = 'h8888888888888888;
    assign set_data[8] = 'h9999999999999999;
    assign set_data[9] = 'haaaaaaaaaaaaaaaa;
    assign set_data[10] = 'hbbbbbbbbbbbbbbbb;
    assign set_data[11] = 'hcccccccccccccccc;
    assign set_data[12] = 'hdddddddddddddddd;
    assign set_data[13] = 'heeeeeeeeeeeeeeee;
    assign set_data[14] = 'hffffffffffffffff;
   
    integer j;
    always_ff @(posedge clk) begin
        if(!rstn) begin 
            location <= 'b0;
            mem_data <= 'b0;
            j <= 'b0;
        end
        else begin
            if (load_mem) begin
                location <= location + 1;
                mem_data <= set_data[j];
                j <= j + 1;
                if(j == 14) j <= 0;
            end
        end
    end
    //dut:
    noise_128_wrapper dut(
        .clk(clk),
        .en(en),
        .rstn(rstn),
        .noise_in(noise_in),
        .noise_out(noise_out),
        .noise_out_valid(valid),
        .noise_in_valid(nvalid),
        .done_wait(done_wait),
        .mem_data(mem_data),
        .location(location),
        .load_mem(load_mem)
    );


    //for gate-keeping:
    
    initial begin
        clk <= 'b0;
        rstn <= 'b0;
        noise_in <= 'b0;
        nvalid <= 'b0;
        load_mem <= 'b0;
        en <= 'b0;
        #20
        rstn <= 'b1;
        en <= 'b0;
        #40
        load_mem <= 'b1;
        //wait:
        forever begin
            @ (posedge clk);
            if(done_wait == 'b1) begin //done waiting, can start noise generation
                load_mem <='b0;
                en <= 'b1;
                nvalid <= 'b1;
                #2000
                $finish();
            end
        end
        $finish();
        //control signals first
    
    end

                                
endmodule