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
    //output [6:0] HEX4,
    //output [6:0] HEX5,

    // Pushbuttons
    input [3:0] KEY,
	// Note that the KEYs are active low, i.e., they are 1'b1 when not pressed. 
	// So if you want them to be 1 when pressed, connect them as ~KEY[0].

    // LEDs
    //output [9:0] LEDR,

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
		logic [7:0] voltage_out;
		logic voltage_valid;
		logic [7:0] voltage_out_channel;
		logic voltage_channel_valid;
		logic [7:0] voltage_out_dfe;
		logic voltage_dfe_valid;
		
		//on-chip-ram connection -> currently cut off:
		
		logic [9:0] address;
		logic clken;
		logic chipselect;
		logic write;
		logic [31:0] readdata;
		logic [31:0] writedata;
		logic [3:0] byteenable;
		
		
		//CTRL signals:
		
		logic prbs_en;
		
		//100MHz clock:
		logic clock;
		logic refclk;
		logic locked;
		
		pll G100MHz (
			.refclk(CLOCK_50),
			.rst(0),
			.outclk_0(clock)
		);
		
		
		
		/////////////////////////////////////TX instatiation /////////////////////////////////////////////
		TX transmitter (
		.clk_clk                                    (clock),                                    //                       clk.clk
		.onchip_memory2_0_s1_address                (address),                //       onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_clken                  (clken),                  //                          .clken
		.onchip_memory2_0_s1_chipselect             (chipselect),             //                          .chipselect
		.onchip_memory2_0_s1_write                  (write),                  //                          .write
		.onchip_memory2_0_s1_readdata               (readdata),               //                          .readdata
		.onchip_memory2_0_s1_writedata              (writedata),              //                          .writedata
		.onchip_memory2_0_s1_byteenable             (byteenable),             //                          .byteenable
		.reset_reset_n                              (reset_n),                              //                     reset.reset_n
		
		
		//gray_encoder
		.gray_encoder_0_data_in_data_in             (prbs_data),             //    gray_encoder_0_data_in.data_in
		.gray_encoder_0_data_in_data_in_valid       (prbs_valid),       //                          .data_in_valid
		.gray_encoder_0_symbol_out_symbol_out       (encoder_out),       // gray_encoder_0_symbol_out.symbol_out
		.gray_encoder_0_symbol_out_symbol_out_valid (encoder_valid), //                          .symbol_out_valid
		
		.pam_encoder_0_symbol_in_symbol_in                       (encoder_out),                       //         pam_encoder_0_symbol_in.symbol_in
		.pam_encoder_0_symbol_in_symbol_in_valid                 (encoder_valid),                 //                                .symbol_in_valid
		.pam_encoder_0_voltage_level_out_voltage_level_out       (voltage_out),       // pam_encoder_0_voltage_level_out.voltage_level_out
		.pam_encoder_0_voltage_level_out_voltage_level_out_valid (voltage_valid), //                                .voltage_level_out_valid
		
		.prbs_0_data_out_data_out                                (prbs_data),                                //                 prbs_0_data_out.data_out
		.prbs_0_data_out_data_out_valid                          (prbs_valid),                          //                                .data_out_valid
		.prbs_0_prbs_ctrl_en                                     (prbs_en)                                    //                prbs_0_prbs_ctrl.en
		);
		
		channel channel_model (
		.clk_clk                                          (clock),                                          //                             clk.clk
		.reset_reset_n                                    (reset_n),                                    //                           reset.reset_n
		.channel_module_0_channel_input_signal_in         (voltage_out),         //  channel_module_0_channel_input.signal_in
		.channel_module_0_channel_input_signal_in_valid   (voltage_valid),   //                                .signal_in_valid
		.channel_module_0_channel_output_signal_out       (voltage_out_channel),       // channel_module_0_channel_output.signal_out
		.channel_module_0_channel_output_signal_out_valid (voltage_channel_valid)  //                                .signal_out_valid
	   );
		
		RX receiver (
		.clk_clk                           (clock),                           //              clk.clk
		.reset_reset_n                     (reset_n),                     //            reset.reset_n
		.dfe_0_dfe_in_signal_in            (voltage_out_channel),            //     dfe_0_dfe_in.signal_in
		.dfe_0_dfe_in_signal_in_valid      (voltage_channel_valid),      //                 .signal_in_valid
		.dfe_0_dfe_out_signal_out          (voltage_out_dfe),          //    dfe_0_dfe_out.signal_out
		.dfe_0_dfe_out_signal_out_valid    (voltage_dfe_valid),    //                 .signal_out_valid
		.dfe_0_noise_noise                 (),                 //      dfe_0_noise.noise
		.dfe_0_train_data_train_data       (),       // dfe_0_train_data.train_data
		.dfe_0_train_data_train_data_valid ()  //                 .train_data_valid
		);
		
		//connecting to button
		assign prbs_en = SW[1]; //
		assign reset_n = KEY[0]; //down = logic 0, up: logic 1
		
		//connecting rest to hex:
		hexDisplay display(
		.clk(clock),
		.rstn(reset_n),
		.voltage_level(voltage_out),
		.voltage_valid (voltage_valid),
		.ones_digit(HEX0),
		.tens_digit(HEX1),
		.hund_digit(HEX2),
		.neg(HEX3)
		);
	

	
endmodule
