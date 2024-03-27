	component TX is
		port (
			clk_clk                                                 : in  std_logic                    := 'X';             -- clk
			gray_encoder_0_data_in_data_in                          : in  std_logic                    := 'X';             -- data_in
			gray_encoder_0_data_in_data_in_valid                    : in  std_logic                    := 'X';             -- data_in_valid
			gray_encoder_0_symbol_out_symbol_out                    : out std_logic_vector(1 downto 0);                    -- symbol_out
			gray_encoder_0_symbol_out_symbol_out_valid              : out std_logic;                                       -- symbol_out_valid
			pam_encoder_0_symbol_in_symbol_in                       : in  std_logic_vector(1 downto 0) := (others => 'X'); -- symbol_in
			pam_encoder_0_symbol_in_symbol_in_valid                 : in  std_logic                    := 'X';             -- symbol_in_valid
			pam_encoder_0_voltage_level_out_voltage_level_out       : out std_logic_vector(7 downto 0);                    -- voltage_level_out
			pam_encoder_0_voltage_level_out_voltage_level_out_valid : out std_logic;                                       -- voltage_level_out_valid
			prbs_0_data_out_data_out                                : out std_logic;                                       -- data_out
			prbs_0_data_out_data_out_valid                          : out std_logic;                                       -- data_out_valid
			prbs_0_prbs_ctrl_en                                     : in  std_logic                    := 'X';             -- en
			reset_reset_n                                           : in  std_logic                    := 'X'              -- reset_n
		);
	end component TX;

	u0 : component TX
		port map (
			clk_clk                                                 => CONNECTED_TO_clk_clk,                                                 --                             clk.clk
			gray_encoder_0_data_in_data_in                          => CONNECTED_TO_gray_encoder_0_data_in_data_in,                          --          gray_encoder_0_data_in.data_in
			gray_encoder_0_data_in_data_in_valid                    => CONNECTED_TO_gray_encoder_0_data_in_data_in_valid,                    --                                .data_in_valid
			gray_encoder_0_symbol_out_symbol_out                    => CONNECTED_TO_gray_encoder_0_symbol_out_symbol_out,                    --       gray_encoder_0_symbol_out.symbol_out
			gray_encoder_0_symbol_out_symbol_out_valid              => CONNECTED_TO_gray_encoder_0_symbol_out_symbol_out_valid,              --                                .symbol_out_valid
			pam_encoder_0_symbol_in_symbol_in                       => CONNECTED_TO_pam_encoder_0_symbol_in_symbol_in,                       --         pam_encoder_0_symbol_in.symbol_in
			pam_encoder_0_symbol_in_symbol_in_valid                 => CONNECTED_TO_pam_encoder_0_symbol_in_symbol_in_valid,                 --                                .symbol_in_valid
			pam_encoder_0_voltage_level_out_voltage_level_out       => CONNECTED_TO_pam_encoder_0_voltage_level_out_voltage_level_out,       -- pam_encoder_0_voltage_level_out.voltage_level_out
			pam_encoder_0_voltage_level_out_voltage_level_out_valid => CONNECTED_TO_pam_encoder_0_voltage_level_out_voltage_level_out_valid, --                                .voltage_level_out_valid
			prbs_0_data_out_data_out                                => CONNECTED_TO_prbs_0_data_out_data_out,                                --                 prbs_0_data_out.data_out
			prbs_0_data_out_data_out_valid                          => CONNECTED_TO_prbs_0_data_out_data_out_valid,                          --                                .data_out_valid
			prbs_0_prbs_ctrl_en                                     => CONNECTED_TO_prbs_0_prbs_ctrl_en,                                     --                prbs_0_prbs_ctrl.en
			reset_reset_n                                           => CONNECTED_TO_reset_reset_n                                            --                           reset.reset_n
		);

