`timescale 1ns / 1ps
module ocm_tb;
    logic clk;
    logic restn;

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
    logic en;
    logic en2;
    //clocks
    always #10 clk = ~clk;

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

  /*  initial begin
        #20
        clk = 'b0;
        addr = 'h024;
        restn = 1;
        wen = 'b0;
        writedata = 'hABCD1234;
        #30
        restn = 0;
        #400 //write
        wen = 'b1;
        //#20 //read
        //wen = 'b0;


        #2120
        $finish;

    end*/
    always_ff @(posedge clk) begin
        if(restn) begin addr2 <= 'h200;
        addr <= 'h200;
        end
        else begin
            if(en2) begin
                addr2 <= addr2 + 2;
                if(addr2 == 'h218) addr2 <= 'h000;
            end
            else if (en) begin
                addr <= addr + 2;
                if(addr == 'h218) addr <= 'h000;
            end
        end
    end

    initial begin
        #20
        clk = 'b0;
        restn = 1;
        wen = 'b0;
        wen2 = 'b0;
        en2 = 'b1;
        en = 'b0;
        #20
        restn = 0;
        repeat(300) @ (posedge clk);
        restn = 1;
        en2 = 'b0;
        en = 'b1;
        #20
        restn = 0;
        repeat(24) @ (posedge clk);
        restn = 1;
        $finish();
    end

endmodule