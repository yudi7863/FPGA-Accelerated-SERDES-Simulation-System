module pam_4_decode #(
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
            symbol_out_valid <= 0;
        end else begin
            if (voltage_level_in_valid) begin
                case(voltage_level_in)
                    'b10101100: symbol_out <= 2'b00;
                    'b11100100: symbol_out <= 2'b01;
                    'b00011100: symbol_out <= 2'b10;
                    'b01010100: symbol_out <= 2'b11;
                endcase
                symbol_out_valid <= 1;
            end else begin
                symbol_out_valid <= 0; // To align with previous valid signal in order to convert back to binary data
            end
        end
    end
endmodule