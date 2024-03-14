
module RX (
	clk_clk,
	gray_decoder_0_data_out_data_out,
	gray_decoder_0_data_out_data_out_valid,
	gray_decoder_0_symbol_in_symbol_in,
	gray_decoder_0_symbol_in_symbol_in_valid,
	pam4_decoder_0_rx_pam4_input_voltage_level_in,
	pam4_decoder_0_rx_pam4_input_voltage_level_in_valid,
	pam4_decoder_0_rx_pam4_output_symbol_out,
	pam4_decoder_0_rx_pam4_output_symbol_out_valid,
	reset_reset_n);	

	input		clk_clk;
	output		gray_decoder_0_data_out_data_out;
	output		gray_decoder_0_data_out_data_out_valid;
	input	[1:0]	gray_decoder_0_symbol_in_symbol_in;
	input		gray_decoder_0_symbol_in_symbol_in_valid;
	input	[7:0]	pam4_decoder_0_rx_pam4_input_voltage_level_in;
	input		pam4_decoder_0_rx_pam4_input_voltage_level_in_valid;
	output	[1:0]	pam4_decoder_0_rx_pam4_output_symbol_out;
	output		pam4_decoder_0_rx_pam4_output_symbol_out_valid;
	input		reset_reset_n;
endmodule
