`timescale 1ns / 1ps

module pam_4_encode #(
    parameter SIGNAL_RESOLUTION,
    parameter SYMBOL_SEPERATION)(
    input clk,
    input rstn,
    input [1:0] symbol_in,
    input symbol_in_valid,
    output reg [SIGNAL_RESOLUTION-1:0] voltage_level_out, //128 to -127 as signed int
    output reg voltage_level_out_valid = 0);

    always @ (posedge clk) begin
        if (!rstn) begin
            voltage_level_out_valid <= 0;
        end else begin
            if (symbol_in_valid) begin
                case(symbol_in)
                    2'b00: voltage_level_out <= -SYMBOL_SEPERATION - (SYMBOL_SEPERATION >> 1);
                    2'b01: voltage_level_out <= -(SYMBOL_SEPERATION >> 1);
                    2'b10: voltage_level_out <= SYMBOL_SEPERATION >> 1;
                    2'b11: voltage_level_out <= SYMBOL_SEPERATION + (SYMBOL_SEPERATION >> 1);
                endcase
                voltage_level_out_valid <= 1;
            end else begin
                voltage_level_out_valid <= 0; // To align with previous valid signal in order to convert back to binary data
            end
        end
    end
endmodule

module pam_4_decode #(
    parameter SIGNAL_RESOLUTION,
    parameter SYMBOL_SEPERATION)(
    input clk,
    input rstn,
    input [SIGNAL_RESOLUTION-1:0] voltage_level_in, 
    input voltage_level_in_valid,
    output reg [1:0] symbol_out,
    output reg symbol_out_valid = 0);

    logic signed [SIGNAL_RESOLUTION-1:0] value [3:0];
    assign value[0] = SYMBOL_SEPERATION >> 1; //28
    assign value[1] = - (SYMBOL_SEPERATION >> 1); //-28
    assign value[2] = value[0] + SYMBOL_SEPERATION; //84
    assign value[3] = value[1] - SYMBOL_SEPERATION; //-84

    always @ (posedge clk) begin
        if (!rstn) begin
            symbol_out_valid <= 0;
        end else begin
            if (voltage_level_in_valid) begin
                case(voltage_level_in)
                    value[3]: symbol_out <= 2'b00;
                    value[1]: symbol_out <= 2'b01;
                    value[0]: symbol_out <= 2'b10;
                    value[2]: symbol_out <= 2'b11;
                endcase
                symbol_out_valid <= 1;
            end else begin
                symbol_out_valid <= 0; // To align with previous valid signal in order to convert back to binary data
            end
        end
    end
endmodule