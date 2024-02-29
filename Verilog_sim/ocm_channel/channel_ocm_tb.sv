`timescale 1ns / 1ps


module channel_ocm_tb;

    //import signals for the ISI_channel:
    parameter PULSE_RESPONSE_LENGTH = 3;
    parameter SIGNAL_RESOLUTION = 8;
    parameter SYMBOL_SEPERATION = 56;
    logic clk, rstn;
    logic [SIGNAL_RESOLUTION-1:0] signal_in,signal_out;
    logic signal_valid;
    logic signal_out_valid;

    //control signals:
    logic load_mem, done_wait;


    //mimicking ocm signals:
    logic [7:0] location;
    logic [63:0] mem_data;
    //ocm related signals:
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

    //clk:
    always #10 clk = ~clk;

    // mimicking the memory to control location and mem_data:
  /*  logic [63:0] set_data[14:0];
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
    end*/


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

    //dut simulation:
    ISI_channel_ocm ISI_channel_ocm (
        .clk(clk),
        .rstn(rstn),
        .signal_in(signal_in),
        .signal_out(signal_out),
        .signal_in_valid(signal_valid),
        .signal_out_valid(signal_out_valid),
        //added control ports:
        .load_mem(load_mem),
        .done_wait(done_wait),
        .location(location),
        .mem_data(readdata2)
    );
    //bring in memory:
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
        .reset(restn),
        .reset_req('b0), 
        .write(wen),
        .writedata(writedata),
        //port2: 64 bits:
        .address2(addr2),
        .byteenable2(), //selecting bytes
        .chipselect2('b1), // must be 1
        .clk2(clk),
        .clken2('b1), //enable clk
        .reset2(restn),
        .reset_req2('b0), 
        .write2(wen2),
        .writedata2(writedata2),

        // outputs:
        .readdata(readdata),
        .readdata2(readdata2)

    );


   initial begin
        clk = 'b0;
        rstn = 'b0;
        signal_in = 'b0;
        signal_valid <= 'b0;
        wen2 <= 0;
        #20;
        rstn = 'b1;
        en2 = 'b1;
        signal_valid <= 'b1;
        load_mem <= 'b1;
        #100
        load_mem <= 'b0;
        #1000;
        $finish();

    end

    


endmodule