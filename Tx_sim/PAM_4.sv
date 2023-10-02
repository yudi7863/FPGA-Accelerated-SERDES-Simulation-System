`timescale 1ns / 1ps

module pam_4_encode#(
    parameter SIGNAL_RESOLUTION = 8,
    parameter SYMBOL_SEPERATION = 56)(
    input clk,
    input rstn,
    input [1:0] symbol_in,
    input symbol_in_valid,
    output reg [SIGNAL_RESOLUTION-1:0] voltage_level_out, //128 to -127 as signed int
    output reg voltage_level_out_valid = 0);

    always @ (posedge clk) begin
        if (!rstn) begin
            voltage_level_out <= 0;
            voltage_level_out_valid <= 0;
        end else begin
            if (symbol_in_valid) begin
                case(symbol_in)
                    2'b00: voltage_level_out <= -'d84;
                    2'b01: voltage_level_out <= -'d28;
                    2'b10: voltage_level_out <= 'd28;
                    2'b11: voltage_level_out <= 'd84;
                endcase
                voltage_level_out_valid <= 1;
            end
        end
    end
endmodule

module pam_4_decode#(
    parameter SIGNAL_RESOLUTION = 8,
    parameter SYMBOL_SEPERATION = 56)(
    input clk,
    input rstn,
    input [SIGNAL_RESOLUTION-1:0] voltage_level_in, 
    input voltage_level_in_valid,
    output reg [1:0] symbol_out,
    output reg symbol_out_valid = 0);

    always @ (posedge clk) begin
        if (!rstn) begin
            symbol_out <= 0;
            symbol_out_valid <= 0;
        end else begin
            if (voltage_level_in_valid) begin
                case(voltage_level_in)
                    -'d84: symbol_out <= 2'b00;
                    -'d28: symbol_out <= 2'b01;
                    'd28: symbol_out <= 2'b10;
                    'd84: symbol_out <= 2'b11;
                endcase
                symbol_out_valid <= 1;
            end
        end
    end
endmodule