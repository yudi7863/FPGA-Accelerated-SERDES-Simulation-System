`timescale 1ns / 1ps
module noise_ocm_tb;
    /////////////////////////noise related signals///////////////////////////////
    //signals:
    logic clk;
    logic en;
    logic rstn;
    logic signed [7:0] noise_in;
    logic nvalid;
    logic valid;
    logic signed [7:0] noise_out;
    //controls:
    logic done_wait;
    logic [7:0] location;
    logic  load_mem;
    //clk:
    always #10 clk = ~clk;

    //////////////////////////ocm related signals///////////////////////////////////
    //32 bits
    logic [14:0] addr;
    logic wen;
    logic [31:0] writedata;
    logic [31:0] readdata;
    //64 bits
    logic [13:0] addr2;
    logic wen2;
    logic [63:0] writedata2;
    logic [63:0] readdata2;

    //others:
    logic en2;
    ///////////////////////////////////control logic//////////////////////////////////
    
    
    always_ff @(posedge clk) begin
        if(!rstn) begin 
            location <= 'b0;
        end
        else begin
            if (load_mem && !wen2) begin
                location <= location + 1;
            end
        end
    end


    always_ff @(posedge clk) begin
        if(!rstn) begin addr2 <= 'b0;
        addr <= 'b0;
        end
        else begin
            if(en2 && !done_wait) begin
                addr2 <= addr2 + 4;
                //if(addr2 == 'h1ff) addr2 <= 'h000;
            end
            else addr2 <= addr2;
        end
    end
    ///////////////////////////modules////////////////////
    noise_128_wrapper dut(
        .clk(clk),
        .en(en),
        .rstn(rstn),
        .noise_in(noise_in),
        .noise_out(noise_out),
        .noise_out_valid(valid),
        .noise_in_valid(nvalid),
        .done_wait(done_wait),
        .mem_data(readdata2),
        .location(location),
        .load_mem(load_mem)
    );

     //dut:
    NIOS_UART_on_chip_mem ocm(
// inputs:
        //port 1: 32 bits:
        .address(addr),
        .byteenable(), //selecting bytes
        .chipselect('b1), // must be 1
        .clk(clk),
        .clken('b1), //enable clk
        .freeze('b0),
        .reset(~rstn),
        .reset_req('b0), 
        .write(wen),
        .writedata(writedata),
        //port2: 64 bits:
        .address2(addr2),
        .byteenable2(), //selecting bytes
        .chipselect2('b1), // must be 1
        .clk2(clk),
        .clken2('b1), //enable clk
        .reset2(~rstn),
        .reset_req2('b0), 
        .write2(wen2),
        .writedata2(writedata2),

        // outputs:
        .readdata(readdata),
        .readdata2(readdata2)

    );
    /////////methods of verifying the probabilities of the occurences of the values:
    //since noise_in <= 'b0, noise_out = noise
    //register to store all the noise_out value, recording the occurences:
    logic [7:0] store_value_pos [63:0];
    logic [7:0] store_value_neg [63:0];
    

    genvar i;
    logic [7:0] temp;
    logic [7:0] test;
    generate 
        for (i = 0; i < 64; i++) begin
            always_ff @(posedge clk) begin
                if (!rstn) begin
                    store_value_pos[i] <= 'b0;
                    store_value_neg[i] <= 'b0;
                end
                else begin
                    if (valid) begin
                        temp <= noise_out;
                        test <= i;
                        if(noise_out[7] == 1'b1 && test == (-temp)) begin //this condition is important
                            store_value_neg[i] <= store_value_neg[i] + 1;
                        end
                        else if (noise_out[7] == 1'b0 && test == temp) begin
                            store_value_pos[i] <= store_value_pos[i] + 1;
                        end
                    end
                end
            end
        end
    endgenerate
    
    initial begin
            //control mem to write
            //wait for done_wait to be asserted
            //start noise operation
        clk <= 'b0;
        rstn <= 'b0;
        noise_in <= 'b0;
        nvalid <= 'b0;
        load_mem <= 'b0;
        en <= 'b0;
        wen = 'b0;
        wen2 = 'b0;
        #20
        rstn <= 1;
        en2 = 'b1;
        load_mem <= 1;
        wait(done_wait);
        load_mem <= 0;
        en <= 'b1;
        nvalid <= 1;
        #2000;
        $finish();

    end



endmodule