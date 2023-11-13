
module RX (
	clk_clk,
	reset_reset_n,
	dfe_0_dfe_in_signal_in,
	dfe_0_dfe_in_signal_in_valid,
	dfe_0_dfe_out_signal_out,
	dfe_0_dfe_out_signal_out_valid,
	dfe_0_noise_noise,
	dfe_0_train_data_train_data,
	dfe_0_train_data_train_data_valid);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	dfe_0_dfe_in_signal_in;
	input		dfe_0_dfe_in_signal_in_valid;
	output	[7:0]	dfe_0_dfe_out_signal_out;
	output		dfe_0_dfe_out_signal_out_valid;
	input	[7:0]	dfe_0_noise_noise;
	input	[7:0]	dfe_0_train_data_train_data;
	input		dfe_0_train_data_train_data_valid;
endmodule
