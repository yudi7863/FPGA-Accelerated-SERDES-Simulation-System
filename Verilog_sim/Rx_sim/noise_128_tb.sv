module noise_128_tb;
    logic address;
    logic byteenable;
    logic chipselect;
    logic clk;
    logic clken;
    logic freeze;
    logic reset;
    logic reset_req;
    logic write;
    logic writedata;

    // outputs:
    logic readdata;


   on_chip_mem OCM (
    .address(address),
    .byteenable(byteenable),
    .chipselect(chipselect),
    .clk(clk),
    .clken(clken),
    .freeze(freeze),
    .reset(reset),
    .reset_req(reset_req),
    .write(write),
    .writedata(writedata),
    .readdata(readdata)
    );

    initial begin
    

    end

                                
endmodule