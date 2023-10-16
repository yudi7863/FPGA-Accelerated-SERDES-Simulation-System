
module TX (
	clk_clk,
	gray_encoder_0_data_in_data_in,
	gray_encoder_0_data_in_data_in_valid,
	gray_encoder_0_symbol_out_symbol_out,
	gray_encoder_0_symbol_out_symbol_out_valid,
	onchip_memory2_0_s1_address,
	onchip_memory2_0_s1_clken,
	onchip_memory2_0_s1_chipselect,
	onchip_memory2_0_s1_write,
	onchip_memory2_0_s1_readdata,
	onchip_memory2_0_s1_writedata,
	onchip_memory2_0_s1_byteenable,
	pam_encoder_0_symbol_in_symbol_in,
	pam_encoder_0_symbol_in_symbol_in_valid,
	pam_encoder_0_voltage_level_out_voltage_level_out,
	pam_encoder_0_voltage_level_out_voltage_level_out_valid,
	prbs_0_data_out_data_out,
	prbs_0_data_out_data_out_valid,
	prbs_0_prbs_ctrl_en,
	reset_reset_n);	

	input		clk_clk;
	input		gray_encoder_0_data_in_data_in;
	input		gray_encoder_0_data_in_data_in_valid;
	output	[1:0]	gray_encoder_0_symbol_out_symbol_out;
	output		gray_encoder_0_symbol_out_symbol_out_valid;
	input	[9:0]	onchip_memory2_0_s1_address;
	input		onchip_memory2_0_s1_clken;
	input		onchip_memory2_0_s1_chipselect;
	input		onchip_memory2_0_s1_write;
	output	[31:0]	onchip_memory2_0_s1_readdata;
	input	[31:0]	onchip_memory2_0_s1_writedata;
	input	[3:0]	onchip_memory2_0_s1_byteenable;
	input	[1:0]	pam_encoder_0_symbol_in_symbol_in;
	input		pam_encoder_0_symbol_in_symbol_in_valid;
	output	[7:0]	pam_encoder_0_voltage_level_out_voltage_level_out;
	output		pam_encoder_0_voltage_level_out_voltage_level_out_valid;
	output		prbs_0_data_out_data_out;
	output		prbs_0_data_out_data_out_valid;
	input		prbs_0_prbs_ctrl_en;
	input		reset_reset_n;
endmodule
