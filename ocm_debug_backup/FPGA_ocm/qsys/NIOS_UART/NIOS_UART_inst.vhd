	component NIOS_UART is
		port (
			clk_clk                        : in  std_logic                     := 'X';             -- clk
			on_chip_mem_reset2_reset       : in  std_logic                     := 'X';             -- reset
			on_chip_mem_reset2_reset_req   : in  std_logic                     := 'X';             -- reset_req
			on_chip_mem_s2_address         : in  std_logic_vector(13 downto 0) := (others => 'X'); -- address
			on_chip_mem_s2_chipselect      : in  std_logic                     := 'X';             -- chipselect
			on_chip_mem_s2_clken           : in  std_logic                     := 'X';             -- clken
			on_chip_mem_s2_write           : in  std_logic                     := 'X';             -- write
			on_chip_mem_s2_readdata        : out std_logic_vector(63 downto 0);                    -- readdata
			on_chip_mem_s2_writedata       : in  std_logic_vector(63 downto 0) := (others => 'X'); -- writedata
			on_chip_mem_s2_byteenable      : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- byteenable
			reset_reset_n                  : in  std_logic                     := 'X';             -- reset_n
			uart_0_external_connection_rxd : in  std_logic                     := 'X';             -- rxd
			uart_0_external_connection_txd : out std_logic                                         -- txd
		);
	end component NIOS_UART;

	u0 : component NIOS_UART
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                        clk.clk
			on_chip_mem_reset2_reset       => CONNECTED_TO_on_chip_mem_reset2_reset,       --         on_chip_mem_reset2.reset
			on_chip_mem_reset2_reset_req   => CONNECTED_TO_on_chip_mem_reset2_reset_req,   --                           .reset_req
			on_chip_mem_s2_address         => CONNECTED_TO_on_chip_mem_s2_address,         --             on_chip_mem_s2.address
			on_chip_mem_s2_chipselect      => CONNECTED_TO_on_chip_mem_s2_chipselect,      --                           .chipselect
			on_chip_mem_s2_clken           => CONNECTED_TO_on_chip_mem_s2_clken,           --                           .clken
			on_chip_mem_s2_write           => CONNECTED_TO_on_chip_mem_s2_write,           --                           .write
			on_chip_mem_s2_readdata        => CONNECTED_TO_on_chip_mem_s2_readdata,        --                           .readdata
			on_chip_mem_s2_writedata       => CONNECTED_TO_on_chip_mem_s2_writedata,       --                           .writedata
			on_chip_mem_s2_byteenable      => CONNECTED_TO_on_chip_mem_s2_byteenable,      --                           .byteenable
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                      reset.reset_n
			uart_0_external_connection_rxd => CONNECTED_TO_uart_0_external_connection_rxd, -- uart_0_external_connection.rxd
			uart_0_external_connection_txd => CONNECTED_TO_uart_0_external_connection_txd  --                           .txd
		);

