
module NIOS_UART (
	clk_clk,
	on_chip_mem_reset2_reset,
	on_chip_mem_reset2_reset_req,
	on_chip_mem_s2_address,
	on_chip_mem_s2_chipselect,
	on_chip_mem_s2_clken,
	on_chip_mem_s2_write,
	on_chip_mem_s2_readdata,
	on_chip_mem_s2_writedata,
	on_chip_mem_s2_byteenable,
	reset_reset_n,
	uart_0_external_connection_rxd,
	uart_0_external_connection_txd);	

	input		clk_clk;
	input		on_chip_mem_reset2_reset;
	input		on_chip_mem_reset2_reset_req;
	input	[14:0]	on_chip_mem_s2_address;
	input		on_chip_mem_s2_chipselect;
	input		on_chip_mem_s2_clken;
	input		on_chip_mem_s2_write;
	output	[31:0]	on_chip_mem_s2_readdata;
	input	[31:0]	on_chip_mem_s2_writedata;
	input	[3:0]	on_chip_mem_s2_byteenable;
	input		reset_reset_n;
	input		uart_0_external_connection_rxd;
	output		uart_0_external_connection_txd;
endmodule
