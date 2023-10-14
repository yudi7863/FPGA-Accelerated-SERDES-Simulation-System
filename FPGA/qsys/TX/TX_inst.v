	TX u0 (
		.clk_clk                                    (<connected-to-clk_clk>),                                    //                       clk.clk
		.onchip_memory2_0_s1_address                (<connected-to-onchip_memory2_0_s1_address>),                //       onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_clken                  (<connected-to-onchip_memory2_0_s1_clken>),                  //                          .clken
		.onchip_memory2_0_s1_chipselect             (<connected-to-onchip_memory2_0_s1_chipselect>),             //                          .chipselect
		.onchip_memory2_0_s1_write                  (<connected-to-onchip_memory2_0_s1_write>),                  //                          .write
		.onchip_memory2_0_s1_readdata               (<connected-to-onchip_memory2_0_s1_readdata>),               //                          .readdata
		.onchip_memory2_0_s1_writedata              (<connected-to-onchip_memory2_0_s1_writedata>),              //                          .writedata
		.onchip_memory2_0_s1_byteenable             (<connected-to-onchip_memory2_0_s1_byteenable>),             //                          .byteenable
		.reset_reset_n                              (<connected-to-reset_reset_n>),                              //                     reset.reset_n
		.gray_encoder_0_data_in_data_in             (<connected-to-gray_encoder_0_data_in_data_in>),             //    gray_encoder_0_data_in.data_in
		.gray_encoder_0_data_in_data_in_valid       (<connected-to-gray_encoder_0_data_in_data_in_valid>),       //                          .data_in_valid
		.gray_encoder_0_symbol_out_symbol_out       (<connected-to-gray_encoder_0_symbol_out_symbol_out>),       // gray_encoder_0_symbol_out.symbol_out
		.gray_encoder_0_symbol_out_symbol_out_valid (<connected-to-gray_encoder_0_symbol_out_symbol_out_valid>), //                          .symbol_out_valid
		.gray_decoder_0_data_out_data_out           (<connected-to-gray_decoder_0_data_out_data_out>),           //   gray_decoder_0_data_out.data_out
		.gray_decoder_0_data_out_data_out_valid     (<connected-to-gray_decoder_0_data_out_data_out_valid>),     //                          .data_out_valid
		.gray_decoder_0_symbol_in_symbol_in         (<connected-to-gray_decoder_0_symbol_in_symbol_in>),         //  gray_decoder_0_symbol_in.symbol_in
		.gray_decoder_0_symbol_in_symbol_in_valid   (<connected-to-gray_decoder_0_symbol_in_symbol_in_valid>)    //                          .symbol_in_valid
	);

