
module TX (
	clk_clk,
	onchip_memory2_0_s1_address,
	onchip_memory2_0_s1_clken,
	onchip_memory2_0_s1_chipselect,
	onchip_memory2_0_s1_write,
	onchip_memory2_0_s1_readdata,
	onchip_memory2_0_s1_writedata,
	onchip_memory2_0_s1_byteenable,
	reset_reset_n,
	gray_encoder_0_data_in_data_in,
	gray_encoder_0_data_in_data_in_valid,
	gray_encoder_0_symbol_out_symbol_out,
	gray_encoder_0_symbol_out_symbol_out_valid,
	gray_decoder_0_data_out_data_out,
	gray_decoder_0_data_out_data_out_valid,
	gray_decoder_0_symbol_in_symbol_in,
	gray_decoder_0_symbol_in_symbol_in_valid);	

	input		clk_clk;
	input	[9:0]	onchip_memory2_0_s1_address;
	input		onchip_memory2_0_s1_clken;
	input		onchip_memory2_0_s1_chipselect;
	input		onchip_memory2_0_s1_write;
	output	[31:0]	onchip_memory2_0_s1_readdata;
	input	[31:0]	onchip_memory2_0_s1_writedata;
	input	[3:0]	onchip_memory2_0_s1_byteenable;
	input		reset_reset_n;
	input		gray_encoder_0_data_in_data_in;
	input		gray_encoder_0_data_in_data_in_valid;
	output	[1:0]	gray_encoder_0_symbol_out_symbol_out;
	output		gray_encoder_0_symbol_out_symbol_out_valid;
	output		gray_decoder_0_data_out_data_out;
	output		gray_decoder_0_data_out_data_out_valid;
	input	[1:0]	gray_decoder_0_symbol_in_symbol_in;
	input		gray_decoder_0_symbol_in_symbol_in_valid;
endmodule
