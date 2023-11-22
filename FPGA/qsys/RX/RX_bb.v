
module RX (
	clk_clk,
	dfe_0_dfe_in_signal_in,
	dfe_0_dfe_in_signal_in_valid,
	dfe_0_dfe_out_signal_out,
	dfe_0_dfe_out_signal_out_valid,
	dfe_0_noise_noise,
	dfe_0_train_data_train_data,
	dfe_0_train_data_train_data_valid,
	reset_reset_n,
	pam4_decoder_0_rx_pam4_input_voltage_level_in,
	pam4_decoder_0_rx_pam4_input_voltage_level_in_valid,
	pam4_decoder_0_rx_pam4_output_symbol_out,
	pam4_decoder_0_rx_pam4_output_symbol_out_valid,
	gray_decoder_0_data_out_data_out,
	gray_decoder_0_data_out_data_out_valid,
	gray_decoder_0_symbol_in_symbol_in,
	gray_decoder_0_symbol_in_symbol_in_valid);	

	input		clk_clk;
	input	[7:0]	dfe_0_dfe_in_signal_in;
	input		dfe_0_dfe_in_signal_in_valid;
	output	[7:0]	dfe_0_dfe_out_signal_out;
	output		dfe_0_dfe_out_signal_out_valid;
	input	[7:0]	dfe_0_noise_noise;
	input	[7:0]	dfe_0_train_data_train_data;
	input		dfe_0_train_data_train_data_valid;
	input		reset_reset_n;
	input	[7:0]	pam4_decoder_0_rx_pam4_input_voltage_level_in;
	input		pam4_decoder_0_rx_pam4_input_voltage_level_in_valid;
	output	[1:0]	pam4_decoder_0_rx_pam4_output_symbol_out;
	output		pam4_decoder_0_rx_pam4_output_symbol_out_valid;
	output		gray_decoder_0_data_out_data_out;
	output		gray_decoder_0_data_out_data_out_valid;
	input	[1:0]	gray_decoder_0_symbol_in_symbol_in;
	input		gray_decoder_0_symbol_in_symbol_in_valid;
endmodule
