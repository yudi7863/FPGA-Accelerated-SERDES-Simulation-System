
module pam_4_encode(
        input clk,
        input rstn,
        parameter SIGNAL_RESOLUTION = 8,
        parameter SYMBOL_SEPERATION = 32,
        input symbol_in[1:0],
        input symbol_valid,
        output voltage_level [SIGNAL_RESOLUTION-1:0], //128 to -127 as signed int
        output reg signal_out_valid =0
);
//code goes here:
    always @ (posedge clk) begin
        if(rstn == 'b0) begin
            voltage_level <= 'b0;
            signal_out_valid <= 'b0;
            count <= 'b0;
            map_valid <= 'b0;
        end
        //interleaving:
        switch (symbol_valid) begin
            // shift valid data into sr
            2'b00: begin
                voltage_level = 'd48;
                signal_out_valid = 'b1;
            end
            2'b01: begin
            end
            2'b10: begin
            end
            2'b11: begin
            end

        end

    end
endmodule