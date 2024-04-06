	component RX is
		port (
			clk_clk                                             : in  std_logic                    := 'X';             -- clk
			gray_decoder_0_data_out_data_out                    : out std_logic;                                       -- data_out
			gray_decoder_0_data_out_data_out_valid              : out std_logic;                                       -- data_out_valid
			gray_decoder_0_symbol_in_symbol_in                  : in  std_logic_vector(1 downto 0) := (others => 'X'); -- symbol_in
			gray_decoder_0_symbol_in_symbol_in_valid            : in  std_logic                    := 'X';             -- symbol_in_valid
			pam4_decoder_0_rx_pam4_input_voltage_level_in       : in  std_logic_vector(7 downto 0) := (others => 'X'); -- voltage_level_in
			pam4_decoder_0_rx_pam4_input_voltage_level_in_valid : in  std_logic                    := 'X';             -- voltage_level_in_valid
			pam4_decoder_0_rx_pam4_output_symbol_out            : out std_logic_vector(1 downto 0);                    -- symbol_out
			pam4_decoder_0_rx_pam4_output_symbol_out_valid      : out std_logic;                                       -- symbol_out_valid
			reset_reset_n                                       : in  std_logic                    := 'X'              -- reset_n
		);
	end component RX;

	u0 : component RX
		port map (
			clk_clk                                             => CONNECTED_TO_clk_clk,                                             --                           clk.clk
			gray_decoder_0_data_out_data_out                    => CONNECTED_TO_gray_decoder_0_data_out_data_out,                    --       gray_decoder_0_data_out.data_out
			gray_decoder_0_data_out_data_out_valid              => CONNECTED_TO_gray_decoder_0_data_out_data_out_valid,              --                              .data_out_valid
			gray_decoder_0_symbol_in_symbol_in                  => CONNECTED_TO_gray_decoder_0_symbol_in_symbol_in,                  --      gray_decoder_0_symbol_in.symbol_in
			gray_decoder_0_symbol_in_symbol_in_valid            => CONNECTED_TO_gray_decoder_0_symbol_in_symbol_in_valid,            --                              .symbol_in_valid
			pam4_decoder_0_rx_pam4_input_voltage_level_in       => CONNECTED_TO_pam4_decoder_0_rx_pam4_input_voltage_level_in,       --  pam4_decoder_0_rx_pam4_input.voltage_level_in
			pam4_decoder_0_rx_pam4_input_voltage_level_in_valid => CONNECTED_TO_pam4_decoder_0_rx_pam4_input_voltage_level_in_valid, --                              .voltage_level_in_valid
			pam4_decoder_0_rx_pam4_output_symbol_out            => CONNECTED_TO_pam4_decoder_0_rx_pam4_output_symbol_out,            -- pam4_decoder_0_rx_pam4_output.symbol_out
			pam4_decoder_0_rx_pam4_output_symbol_out_valid      => CONNECTED_TO_pam4_decoder_0_rx_pam4_output_symbol_out_valid,      --                              .symbol_out_valid
			reset_reset_n                                       => CONNECTED_TO_reset_reset_n                                        --                         reset.reset_n
		);

