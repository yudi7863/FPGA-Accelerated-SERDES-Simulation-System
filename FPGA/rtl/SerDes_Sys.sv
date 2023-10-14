module SerDes_Sys(
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
		//tx connections
		logic reset_n;
		logic prbs_data;
		logic prbs_valid;
		logic encoder_valid;
		logic decoder_valid;
		logic [1:0] encoder_out;
		logic [1:0] decoder_in;
		logic decoder_out;
		logic decoder_out_valid;
		
		//on-chip-ram connection -> currently cut off:
		
		logic [9:0] address;
		logic clken;
		logic chipselect;
		logic write;
		logic [31:0] readdata;
		logic [31:0] writedata;
		logic [3:0] byteenable;
		
		//100MHz clock:
		logic clock;
		logic refclk;
		
		pll G100MHz (
			.refclk(CLOCK50),
			.rst(reset_n),
			.outclk_0(clock)
		);
		
		
		
		/////////////////////////////////////TX instatiation /////////////////////////////////////////////
		TX u0 (
		.clk_clk                                    (clock),                                    //                       clk.clk
		.onchip_memory2_0_s1_address                (address),                //       onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_clken                  (clken),                  //                          .clken
		.onchip_memory2_0_s1_chipselect             (chipselect),             //                          .chipselect
		.onchip_memory2_0_s1_write                  (write),                  //                          .write
		.onchip_memory2_0_s1_readdata               (readdata),               //                          .readdata
		.onchip_memory2_0_s1_writedata              (writedata),              //                          .writedata
		.onchip_memory2_0_s1_byteenable             (byteenable),             //                          .byteenable
		.reset_reset_n                              (reset_n),                              //                     reset.reset_n
		.gray_encoder_0_data_in_data_in             (prbs_data),             //    gray_encoder_0_data_in.data_in
		.gray_encoder_0_data_in_data_in_valid       (prbs_valid),       //                          .data_in_valid
		.gray_encoder_0_symbol_out_symbol_out       (encoder_out),       // gray_encoder_0_symbol_out.symbol_out
		.gray_encoder_0_symbol_out_symbol_out_valid (encoder_valid), //                          .symbol_out_valid
		.gray_decoder_0_data_out_data_out           (decoder_out),           //   gray_decoder_0_data_out.data_out
		.gray_decoder_0_data_out_data_out_valid     (decoder_out_valid),     //                          .data_out_valid
		.gray_decoder_0_symbol_in_symbol_in         (decoder_in),         //  gray_decoder_0_symbol_in.symbol_in
		.gray_decoder_0_symbol_in_symbol_in_valid   (decoder_valid)    //                          .symbol_in_valid
		);


	
endmodule
