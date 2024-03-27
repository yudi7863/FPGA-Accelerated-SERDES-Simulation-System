
module TX (
	clk_clk,
	gray_encoder_0_data_in_data_in,
	gray_encoder_0_data_in_data_in_valid,
	gray_encoder_0_symbol_out_symbol_out,
	gray_encoder_0_symbol_out_symbol_out_valid,
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
	input	[1:0]	pam_encoder_0_symbol_in_symbol_in;
	input		pam_encoder_0_symbol_in_symbol_in_valid;
	output	[7:0]	pam_encoder_0_voltage_level_out_voltage_level_out;
	output		pam_encoder_0_voltage_level_out_voltage_level_out_valid;
	output		prbs_0_data_out_data_out;
	output		prbs_0_data_out_data_out_valid;
	input		prbs_0_prbs_ctrl_en;
	input		reset_reset_n;
endmodule
