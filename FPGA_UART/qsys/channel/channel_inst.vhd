	component channel is
		port (
			clk_clk                                          : in  std_logic                    := 'X';             -- clk
			reset_reset_n                                    : in  std_logic                    := 'X';             -- reset_n
			channel_module_0_channel_input_signal_in         : in  std_logic_vector(7 downto 0) := (others => 'X'); -- signal_in
			channel_module_0_channel_input_signal_in_valid   : in  std_logic                    := 'X';             -- signal_in_valid
			channel_module_0_channel_output_signal_out       : out std_logic_vector(7 downto 0);                    -- signal_out
			channel_module_0_channel_output_signal_out_valid : out std_logic                                        -- signal_out_valid
		);
	end component channel;

	u0 : component channel
		port map (
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                             clk.clk
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n,                                    --                           reset.reset_n
			channel_module_0_channel_input_signal_in         => CONNECTED_TO_channel_module_0_channel_input_signal_in,         --  channel_module_0_channel_input.signal_in
			channel_module_0_channel_input_signal_in_valid   => CONNECTED_TO_channel_module_0_channel_input_signal_in_valid,   --                                .signal_in_valid
			channel_module_0_channel_output_signal_out       => CONNECTED_TO_channel_module_0_channel_output_signal_out,       -- channel_module_0_channel_output.signal_out
			channel_module_0_channel_output_signal_out_valid => CONNECTED_TO_channel_module_0_channel_output_signal_out_valid  --                                .signal_out_valid
		);

