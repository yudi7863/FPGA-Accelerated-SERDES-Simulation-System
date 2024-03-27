`timescale 1ns / 1ps

module urng_64 #(
    parameter SEED0 = 64'd5030521883283424767,
    parameter SEED1 = 64'd18445829279364155008,
    parameter SEED2 = 64'd18436106298727503359
    )(
    
    input clk,                    
    input rstn,                 

    // Data interface
    input en,
    input start_control,                     
    output reg valid,       
    output reg [63:0] data_out   
    );

    // Local variables
    reg [63:0] z1, z2, z3;
    wire [63:0] z1_next, z2_next, z3_next;
    
    reg [63:0] data_out_full;
    
    //assign data_out = data_out_full[31:0];
    
    // Update state
    assign z1_next = {z1[39:1], z1[58:34] ^ z1[63:39]};
    assign z2_next = {z2[50:6], z2[44:26] ^ z2[63:45]};
    assign z3_next = {z3[56:9], z3[39:24] ^ z3[63:48]};
    
    always @ (posedge clk) begin
        if (!rstn) begin
            z1 <= SEED0;
            z2 <= SEED1;
            z3 <= SEED2;
        end
        else if (en) begin
            z1 <= z1_next;
            z2 <= z2_next;
            z3 <= z3_next;
        end
    end
    
    
    // Output data
    always @ (posedge clk) begin
        if (!rstn)
            valid <= 1'b0;
        else
            valid <= en;
    end
    
    always @ (posedge clk) begin
        if (!rstn)
            data_out <= 64'd0;
        else
            data_out <= (z1_next ^ z2_next ^ z3_next);
    end
    
    
endmodule


