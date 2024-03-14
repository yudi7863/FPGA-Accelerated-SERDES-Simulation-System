	NIOS_UART u0 (
		.clk_clk                        (<connected-to-clk_clk>),                        //                        clk.clk
		.on_chip_mem_reset2_reset       (<connected-to-on_chip_mem_reset2_reset>),       //         on_chip_mem_reset2.reset
		.on_chip_mem_reset2_reset_req   (<connected-to-on_chip_mem_reset2_reset_req>),   //                           .reset_req
		.on_chip_mem_s2_address         (<connected-to-on_chip_mem_s2_address>),         //             on_chip_mem_s2.address
		.on_chip_mem_s2_chipselect      (<connected-to-on_chip_mem_s2_chipselect>),      //                           .chipselect
		.on_chip_mem_s2_clken           (<connected-to-on_chip_mem_s2_clken>),           //                           .clken
		.on_chip_mem_s2_write           (<connected-to-on_chip_mem_s2_write>),           //                           .write
		.on_chip_mem_s2_readdata        (<connected-to-on_chip_mem_s2_readdata>),        //                           .readdata
		.on_chip_mem_s2_writedata       (<connected-to-on_chip_mem_s2_writedata>),       //                           .writedata
		.on_chip_mem_s2_byteenable      (<connected-to-on_chip_mem_s2_byteenable>),      //                           .byteenable
		.reset_reset_n                  (<connected-to-reset_reset_n>),                  //                      reset.reset_n
		.uart_0_external_connection_rxd (<connected-to-uart_0_external_connection_rxd>), // uart_0_external_connection.rxd
		.uart_0_external_connection_txd (<connected-to-uart_0_external_connection_txd>)  //                           .txd
	);

