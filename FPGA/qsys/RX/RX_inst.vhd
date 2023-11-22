	component RX is
		port (
			clk_clk                                             : in  std_logic                    := 'X';             -- clk
			dfe_0_dfe_in_signal_in                              : in  std_logic_vector(7 downto 0) := (others => 'X'); -- signal_in
			dfe_0_dfe_in_signal_in_valid                        : in  std_logic                    := 'X';             -- signal_in_valid
			dfe_0_dfe_out_signal_out                            : out std_logic_vector(7 downto 0);                    -- signal_out
			dfe_0_dfe_out_signal_out_valid                      : out std_logic;                                       -- signal_out_valid
			dfe_0_noise_noise                                   : in  std_logic_vector(7 downto 0) := (others => 'X'); -- noise
			dfe_0_train_data_train_data                         : in  std_logic_vector(7 downto 0) := (others => 'X'); -- train_data
			dfe_0_train_data_train_data_valid                   : in  std_logic                    := 'X';             -- train_data_valid
			reset_reset_n                                       : in  std_logic                    := 'X';             -- reset_n
			pam4_decoder_0_rx_pam4_input_voltage_level_in       : in  std_logic_vector(7 downto 0) := (others => 'X'); -- voltage_level_in
			pam4_decoder_0_rx_pam4_input_voltage_level_in_valid : in  std_logic                    := 'X';             -- voltage_level_in_valid
			pam4_decoder_0_rx_pam4_output_symbol_out            : out std_logic_vector(1 downto 0);                    -- symbol_out
			pam4_decoder_0_rx_pam4_output_symbol_out_valid      : out std_logic;                                       -- symbol_out_valid
			gray_decoder_0_data_out_data_out                    : out std_logic;                                       -- data_out
			gray_decoder_0_data_out_data_out_valid              : out std_logic;                                       -- data_out_valid
			gray_decoder_0_symbol_in_symbol_in                  : in  std_logic_vector(1 downto 0) := (others => 'X'); -- symbol_in
			gray_decoder_0_symbol_in_symbol_in_valid            : in  std_logic                    := 'X'              -- symbol_in_valid
		);
	end component RX;

	u0 : component RX
		port map (
			clk_clk                                             => CONNECTED_TO_clk_clk,                                             --                           clk.clk
			dfe_0_dfe_in_signal_in                              => CONNECTED_TO_dfe_0_dfe_in_signal_in,                              --                  dfe_0_dfe_in.signal_in
			dfe_0_dfe_in_signal_in_valid                        => CONNECTED_TO_dfe_0_dfe_in_signal_in_valid,                        --                              .signal_in_valid
			dfe_0_dfe_out_signal_out                            => CONNECTED_TO_dfe_0_dfe_out_signal_out,                            --                 dfe_0_dfe_out.signal_out
			dfe_0_dfe_out_signal_out_valid                      => CONNECTED_TO_dfe_0_dfe_out_signal_out_valid,                      --                              .signal_out_valid
			dfe_0_noise_noise                                   => CONNECTED_TO_dfe_0_noise_noise,                                   --                   dfe_0_noise.noise
			dfe_0_train_data_train_data                         => CONNECTED_TO_dfe_0_train_data_train_data,                         --              dfe_0_train_data.train_data
			dfe_0_train_data_train_data_valid                   => CONNECTED_TO_dfe_0_train_data_train_data_valid,                   --                              .train_data_valid
			reset_reset_n                                       => CONNECTED_TO_reset_reset_n,                                       --                         reset.reset_n
			pam4_decoder_0_rx_pam4_input_voltage_level_in       => CONNECTED_TO_pam4_decoder_0_rx_pam4_input_voltage_level_in,       --  pam4_decoder_0_rx_pam4_input.voltage_level_in
			pam4_decoder_0_rx_pam4_input_voltage_level_in_valid => CONNECTED_TO_pam4_decoder_0_rx_pam4_input_voltage_level_in_valid, --                              .voltage_level_in_valid
			pam4_decoder_0_rx_pam4_output_symbol_out            => CONNECTED_TO_pam4_decoder_0_rx_pam4_output_symbol_out,            -- pam4_decoder_0_rx_pam4_output.symbol_out
			pam4_decoder_0_rx_pam4_output_symbol_out_valid      => CONNECTED_TO_pam4_decoder_0_rx_pam4_output_symbol_out_valid,      --                              .symbol_out_valid
			gray_decoder_0_data_out_data_out                    => CONNECTED_TO_gray_decoder_0_data_out_data_out,                    --       gray_decoder_0_data_out.data_out
			gray_decoder_0_data_out_data_out_valid              => CONNECTED_TO_gray_decoder_0_data_out_data_out_valid,              --                              .data_out_valid
			gray_decoder_0_symbol_in_symbol_in                  => CONNECTED_TO_gray_decoder_0_symbol_in_symbol_in,                  --      gray_decoder_0_symbol_in.symbol_in
			gray_decoder_0_symbol_in_symbol_in_valid            => CONNECTED_TO_gray_decoder_0_symbol_in_symbol_in_valid             --                              .symbol_in_valid
		);

