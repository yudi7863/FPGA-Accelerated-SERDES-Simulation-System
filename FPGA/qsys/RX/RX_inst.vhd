	component RX is
		port (
			clk_clk                           : in  std_logic                    := 'X';             -- clk
			reset_reset_n                     : in  std_logic                    := 'X';             -- reset_n
			dfe_0_dfe_in_signal_in            : in  std_logic_vector(7 downto 0) := (others => 'X'); -- signal_in
			dfe_0_dfe_in_signal_in_valid      : in  std_logic                    := 'X';             -- signal_in_valid
			dfe_0_dfe_out_signal_out          : out std_logic_vector(7 downto 0);                    -- signal_out
			dfe_0_dfe_out_signal_out_valid    : out std_logic;                                       -- signal_out_valid
			dfe_0_noise_noise                 : in  std_logic_vector(7 downto 0) := (others => 'X'); -- noise
			dfe_0_train_data_train_data       : in  std_logic_vector(7 downto 0) := (others => 'X'); -- train_data
			dfe_0_train_data_train_data_valid : in  std_logic                    := 'X'              -- train_data_valid
		);
	end component RX;

	u0 : component RX
		port map (
			clk_clk                           => CONNECTED_TO_clk_clk,                           --              clk.clk
			reset_reset_n                     => CONNECTED_TO_reset_reset_n,                     --            reset.reset_n
			dfe_0_dfe_in_signal_in            => CONNECTED_TO_dfe_0_dfe_in_signal_in,            --     dfe_0_dfe_in.signal_in
			dfe_0_dfe_in_signal_in_valid      => CONNECTED_TO_dfe_0_dfe_in_signal_in_valid,      --                 .signal_in_valid
			dfe_0_dfe_out_signal_out          => CONNECTED_TO_dfe_0_dfe_out_signal_out,          --    dfe_0_dfe_out.signal_out
			dfe_0_dfe_out_signal_out_valid    => CONNECTED_TO_dfe_0_dfe_out_signal_out_valid,    --                 .signal_out_valid
			dfe_0_noise_noise                 => CONNECTED_TO_dfe_0_noise_noise,                 --      dfe_0_noise.noise
			dfe_0_train_data_train_data       => CONNECTED_TO_dfe_0_train_data_train_data,       -- dfe_0_train_data.train_data
			dfe_0_train_data_train_data_valid => CONNECTED_TO_dfe_0_train_data_train_data_valid  --                 .train_data_valid
		);

