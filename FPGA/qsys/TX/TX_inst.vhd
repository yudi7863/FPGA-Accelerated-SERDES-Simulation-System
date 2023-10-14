	component TX is
		port (
			clk_clk                                    : in  std_logic                     := 'X';             -- clk
			onchip_memory2_0_s1_address                : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			onchip_memory2_0_s1_clken                  : in  std_logic                     := 'X';             -- clken
			onchip_memory2_0_s1_chipselect             : in  std_logic                     := 'X';             -- chipselect
			onchip_memory2_0_s1_write                  : in  std_logic                     := 'X';             -- write
			onchip_memory2_0_s1_readdata               : out std_logic_vector(31 downto 0);                    -- readdata
			onchip_memory2_0_s1_writedata              : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			onchip_memory2_0_s1_byteenable             : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			reset_reset_n                              : in  std_logic                     := 'X';             -- reset_n
			gray_encoder_0_data_in_data_in             : in  std_logic                     := 'X';             -- data_in
			gray_encoder_0_data_in_data_in_valid       : in  std_logic                     := 'X';             -- data_in_valid
			gray_encoder_0_symbol_out_symbol_out       : out std_logic_vector(1 downto 0);                     -- symbol_out
			gray_encoder_0_symbol_out_symbol_out_valid : out std_logic;                                        -- symbol_out_valid
			gray_decoder_0_data_out_data_out           : out std_logic;                                        -- data_out
			gray_decoder_0_data_out_data_out_valid     : out std_logic;                                        -- data_out_valid
			gray_decoder_0_symbol_in_symbol_in         : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- symbol_in
			gray_decoder_0_symbol_in_symbol_in_valid   : in  std_logic                     := 'X'              -- symbol_in_valid
		);
	end component TX;

	u0 : component TX
		port map (
			clk_clk                                    => CONNECTED_TO_clk_clk,                                    --                       clk.clk
			onchip_memory2_0_s1_address                => CONNECTED_TO_onchip_memory2_0_s1_address,                --       onchip_memory2_0_s1.address
			onchip_memory2_0_s1_clken                  => CONNECTED_TO_onchip_memory2_0_s1_clken,                  --                          .clken
			onchip_memory2_0_s1_chipselect             => CONNECTED_TO_onchip_memory2_0_s1_chipselect,             --                          .chipselect
			onchip_memory2_0_s1_write                  => CONNECTED_TO_onchip_memory2_0_s1_write,                  --                          .write
			onchip_memory2_0_s1_readdata               => CONNECTED_TO_onchip_memory2_0_s1_readdata,               --                          .readdata
			onchip_memory2_0_s1_writedata              => CONNECTED_TO_onchip_memory2_0_s1_writedata,              --                          .writedata
			onchip_memory2_0_s1_byteenable             => CONNECTED_TO_onchip_memory2_0_s1_byteenable,             --                          .byteenable
			reset_reset_n                              => CONNECTED_TO_reset_reset_n,                              --                     reset.reset_n
			gray_encoder_0_data_in_data_in             => CONNECTED_TO_gray_encoder_0_data_in_data_in,             --    gray_encoder_0_data_in.data_in
			gray_encoder_0_data_in_data_in_valid       => CONNECTED_TO_gray_encoder_0_data_in_data_in_valid,       --                          .data_in_valid
			gray_encoder_0_symbol_out_symbol_out       => CONNECTED_TO_gray_encoder_0_symbol_out_symbol_out,       -- gray_encoder_0_symbol_out.symbol_out
			gray_encoder_0_symbol_out_symbol_out_valid => CONNECTED_TO_gray_encoder_0_symbol_out_symbol_out_valid, --                          .symbol_out_valid
			gray_decoder_0_data_out_data_out           => CONNECTED_TO_gray_decoder_0_data_out_data_out,           --   gray_decoder_0_data_out.data_out
			gray_decoder_0_data_out_data_out_valid     => CONNECTED_TO_gray_decoder_0_data_out_data_out_valid,     --                          .data_out_valid
			gray_decoder_0_symbol_in_symbol_in         => CONNECTED_TO_gray_decoder_0_symbol_in_symbol_in,         --  gray_decoder_0_symbol_in.symbol_in
			gray_decoder_0_symbol_in_symbol_in_valid   => CONNECTED_TO_gray_decoder_0_symbol_in_symbol_in_valid    --                          .symbol_in_valid
		);

