`timescale 1ns / 1ps
module rx_standalone_tb ();

    //making random data:
    logic [455:0] random_data;
    assign random_data = 'hE45454545454E4E4ACAC545454ACACACACAC1C1CACAC1C1CE4E4E4E45454ACACACAC545454ACACACACE4E4ACACACAC1C1CE4E4E4E4ACAC1C1C;
    logic clk;
    logic resetn;
    
    //output from PAM4:
    logic [7:0] voltage_level;
    logic voltage_level_valid;
    //output from channel:
    logic [7:0] voltage_level_isi;
    logic signal_valid;
    //output from DFE:
    logic [7:0] no_isi;
    logic no_isi_valid;
    logic [7:0] shift_data;
    logic [9:0] count;

    always #10 clk = ~clk;
    //logic for intiailizing random_data for voltage_level:
    always_ff @ (posedge clk) begin
        if(!resetn) begin
            voltage_level <= 'b0;
            voltage_level_valid <= 'b0;
            count <= 'b0;
        end
        else begin
            voltage_level <= random_data[count*8 +: 8];
            voltage_level_valid <= ~voltage_level_valid;
            count <= count + 1;
            if(count > 'd56) count <= 'b0;
        end
    end

    //connections
    ISI_channel channel(
        .clk(clk),
        .rstn(resetn),
        .signal_in(voltage_level),
        .signal_in_valid(voltage_level_valid),
        .signal_out(voltage_level_isi),
        .signal_out_valid(signal_valid));

    DFE DecisionFeedback(
        .clk(clk),
        .rstn(resetn),
        .signal_in(voltage_level_isi),
        .signal_in_valid(signal_valid),
        .signal_out(no_isi),
        .signal_out_valid(no_isi_valid));
 
    //simulation begin
    initial begin
        clk <= 'b0;
        resetn <= 'b0;
        #50 
        
        resetn <=1;
        #2120
        
        $finish;

        
    end
endmodule