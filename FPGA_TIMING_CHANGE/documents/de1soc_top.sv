module de1soc_top 
(
	// These are the inputs/outputs available on the DE1-SoC board.
	// Feel free to use the subset of these that you need -- unused pins will be ignored.
	// Please note that this project also specifies the correct board  
	// and loads the pin assignments so you do not need to worry about when using this kit. 
	
    // Clock pins
    input CLOCK_50,

    // Seven Segment Displays
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,

    // Pushbuttons
    input [3:0] KEY,
	// Note that the KEYs are active low, i.e., they are 1'b1 when not pressed. 
	// So if you want them to be 1 when pressed, connect them as ~KEY[0].

    // LEDs
    output [9:0] LEDR,

    // Slider Switches
    input [9:0] SW
);
	
	// Declare the signals you need to connect the top level signals to your design. 	
	// data_out is a sample 4-bit signal to show how to connect to the LEDRs and HEX. 
	logic [3:0] data_out;
	
	// < Instantiate your module here> 	
. 
	
	// Sample HEX decoder instantiation.
	hex_decoder hexdec_0
	(
		.hex_digit(data_out[3:0]),
		.segments(HEX0)
	);
		
	// Turn off HEXes you don't need
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	
endmodule


// HEX decoder module. 
module hex_decoder
(
	input [3:0] hex_digit,
	output logic [6:0] segments
);
    always_comb begin
        case (hex_digit)
            4'h0: segments = 7'b1000000;
            4'h1: segments = 7'b1111001;
            4'h2: segments = 7'b0100100;
            4'h3: segments = 7'b0110000;
            4'h4: segments = 7'b0011001;
            4'h5: segments = 7'b0010010;
            4'h6: segments = 7'b0000010;
            4'h7: segments = 7'b1111000;
            4'h8: segments = 7'b0000000;
            4'h9: segments = 7'b0011000;
            4'hA: segments = 7'b0001000;
            4'hB: segments = 7'b0000011;
            4'hC: segments = 7'b1000110;
            4'hD: segments = 7'b0100001;
            4'hE: segments = 7'b0000110;
            4'hF: segments = 7'b0001110;   
            default: segments = 7'h7f;	// Display 0 by default 
        endcase
	end
endmodule
