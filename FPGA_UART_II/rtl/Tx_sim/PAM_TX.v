module pam_4_encode #(
    parameter SIGNAL_RESOLUTION = 8,
    parameter SYMBOL_SEPERATION = 56)(
    input clk,
    input rstn,
    input [1:0] symbol_in,
    input symbol_in_valid,
    output reg [SIGNAL_RESOLUTION-1:0] voltage_level_out, //128 to -127 as signed int
    output reg voltage_level_out_valid = 0);

    always @ (posedge clk  or negedge rstn) begin
        if (!rstn) begin
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
            end else begin
                voltage_level_out_valid <= 0; // To align with previous valid signal in order to convert back to binary data
            end
        end
    end
endmodule