module SerDes_Sys(
	// These are the inputs/outputs available on the DE1-SoC board.
	// Feel free to use the subset of these that you need -- unused pins will be ignored.
	// Please note that this project also specifies the correct board  
	// and loads the pin assignments so you do not need to worry about when using this kit. 
	
    // Clock pins
    input CLOCK_50,

    // Seven Segment Displays
    
    // Pushbuttons
    input [3:0] KEY,
	// Note that the KEYs are active low, i.e., they are 1'b1 when not pressed. 
	// So if you want them to be 1 when pressed, connect them as ~KEY[0].

    // LEDs
    output [9:0] LEDR,

    // Slider Switches
    input [9:0] SW,
	 //uart
	 input HPS_UART_RX, //assigned pin and generated qsys
	 output HPS_UART_TX
);
		//tx connections
		logic reset_n;
		logic prbs_data;
		logic prbs_valid;
		logic [1:0] encoder_out;
		logic encoder_valid;
		logic [7:0] voltage_out;
		logic voltage_valid;
		
		//channel connections
		logic [7:0] voltage_out_channel;
		logic voltage_channel_valid;
		
		//rx connections
		logic [7:0] voltage_out_dfe;
		logic voltage_dfe_valid;
		logic [1:0] decoder_in;
		logic decoder_valid;
		logic decoder_out;
		logic decoder_out_valid;
		
		
		
		
		//noise control signals:
		logic done_wait;
		logic [7:0] location;
		logic  load_mem;
		logic load_mem_pressed;
		//on-chip-ram connection -> connect to UART:
		 logic [13:0] addr2;
		 logic wen2;
		 logic [63:0] writedata2;
		 logic [63:0] readdata2;

		
		
		//CTRL signals:
		logic uart_rx;
		logic uart_tx;
		logic prbs_en;
		
		//100MHz clock:
		logic clock;
		logic refclk;
		logic locked;
		
		pll G100MHz (
			.refclk(CLOCK_50),
			.rst(0),
			.outclk_0(clock)
		);
		
		
		
		/////////////////////////////////////TX instatiation /////////////////////////////////////////////
		TX transmitter (
		.clk_clk                                    (clock),                                    //                       clk.clk
		.reset_reset_n                              (reset_n),                              //                     reset.reset_n
		
		
		//gray_encoder
		.gray_encoder_0_data_in_data_in             (prbs_data),             //    gray_encoder_0_data_in.data_in
		.gray_encoder_0_data_in_data_in_valid       (prbs_valid),       //                          .data_in_valid
		.gray_encoder_0_symbol_out_symbol_out       (encoder_out),       // gray_encoder_0_symbol_out.symbol_out
		.gray_encoder_0_symbol_out_symbol_out_valid (encoder_valid), //                          .symbol_out_valid
		
		.pam_encoder_0_symbol_in_symbol_in                       (encoder_out),                       //         pam_encoder_0_symbol_in.symbol_in
		.pam_encoder_0_symbol_in_symbol_in_valid                 (encoder_valid),                 //                                .symbol_in_valid
		.pam_encoder_0_voltage_level_out_voltage_level_out       (voltage_out),       // pam_encoder_0_voltage_level_out.voltage_level_out
		.pam_encoder_0_voltage_level_out_voltage_level_out_valid (voltage_valid), //                                .voltage_level_out_valid
		
		.prbs_0_data_out_data_out                                (prbs_data),                                //                 prbs_0_data_out.data_out
		.prbs_0_data_out_data_out_valid                          (prbs_valid),                          //                                .data_out_valid
		.prbs_0_prbs_ctrl_en                                     (prbs_en)                                    //                prbs_0_prbs_ctrl.en
		);
		
		channel channel_model (
		.clk_clk                                          (clock),                                          //                             clk.clk
		.reset_reset_n                                    (reset_n),                                    //                           reset.reset_n
		.channel_module_0_channel_input_signal_in         (voltage_out),         //  channel_module_0_channel_input.signal_in
		.channel_module_0_channel_input_signal_in_valid   (voltage_valid),   //                                .signal_in_valid
		.channel_module_0_channel_output_signal_out       (voltage_out_channel),       // channel_module_0_channel_output.signal_out
		.channel_module_0_channel_output_signal_out_valid (voltage_channel_valid)  //                                .signal_out_valid
	   );
		
		
		///////////////////////////////////////////////////////////noise instantiation////////////////////////////////////////////////////////////
		logic [7:0] noise_output;
      logic noise_valid;
		
		always_ff @(posedge clock) begin
        if(!reset_n) begin 
            location <= 'b0;
        end
        else begin
            if (load_mem && !wen2 && !done_wait) begin
                location <= location + 1;
            end
				else location <= location;
        end
		end
		
		always_ff @(posedge clock) begin
        if(!reset_n) addr2 <= 'b0;
      
        else begin
            if(!done_wait && load_mem) begin
                addr2 <= addr2 + 2;
            end
            else addr2 <= addr2;
        end
      end
		
		
		
		logic noise_enable;
		logic noise_in_valid_i;
		logic noise_in_valid;
		/*always_ff @(posedge clock) begin
			if(!reset_n) begin 
				noise_enable <= 'b0;
				noise_in_valid <= 'b0;
			end
			else begin
				if(done_wait == 'b1) begin
					noise_enable <= prbs_en;
					noise_in_valid <= voltage_channel_valid;
					load_mem <= 'b0;
				end
			end
		end*/
		
		parameter WAIT_MEM = 2'b00, LOAD_MEM = 2'b01, DONE_WAIT = 2'b10;
		logic [1:0] ctrl_state;
		
		always_ff @(posedge clock) begin
			if(!reset_n) begin
				ctrl_state = WAIT_MEM;
				noise_enable <= 'b0;
				noise_in_valid_i <= 'b0;
			end
			else begin
				case(ctrl_state)
					WAIT_MEM: begin if (load_mem_pressed) begin
										load_mem <= 'b1;
										ctrl_state <= LOAD_MEM;
								 end
								 else begin
									load_mem <= 1'b0;
									ctrl_state <= WAIT_MEM;
								end
								end
					LOAD_MEM: begin if(done_wait) begin
										load_mem <= 'b0;
										noise_enable <= prbs_en;
										noise_in_valid_i <= voltage_channel_valid;
										ctrl_state <= DONE_WAIT;
								end
								else ctrl_state <= LOAD_MEM;
								end
					DONE_WAIT: begin ctrl_state <= DONE_WAIT; //can technically put prbs_en here
								   noise_enable <= prbs_en;
									noise_in_valid_i <= voltage_channel_valid;
									end
					default: ctrl_state <= WAIT_MEM;
				endcase
			end
		end
		
		always_ff @ (posedge clock) begin
			if(!reset_n) noise_in_valid <= 'b0;
			else begin
				if(noise_in_valid_i) begin
					noise_in_valid <= 'b1;
				end
				else noise_in_valid <= noise_in_valid;
			end
		end
		///probablemattic readdata2: inverted ??
		logic [63:0] noise_data;
		assign noise_data = {readdata2[31:0],readdata2[63:32]};
		noise_128_wrapper noise_wrapper_noise (
            .clk(clock),
            .en(noise_enable), //yudi: need to change this later
            .rstn(reset_n),
            .noise_in(voltage_out_channel),
				.noise_in_valid(noise_in_valid),
            .noise_out(noise_output),
            .noise_out_valid(noise_valid),
				.done_wait(done_wait), //////for loading signals
			   .mem_data(noise_data),
			   .location(location),
			   .load_mem(load_mem)
    );
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		RX receiver (
		.clk_clk                                             (clock),                                             //                           clk.clk
		.dfe_0_dfe_in_signal_in                              (noise_output),                              //                  dfe_0_dfe_in.signal_in
		.dfe_0_dfe_in_signal_in_valid                        (noise_valid),                        //                              .signal_in_valid
		.dfe_0_dfe_out_signal_out                            (voltage_out_dfe),                            //                 dfe_0_dfe_out.signal_out
		.dfe_0_dfe_out_signal_out_valid                      (voltage_dfe_valid),                      //                              .signal_out_valid
		.dfe_0_noise_noise                                   (),                                   //                   dfe_0_noise.noise
		.dfe_0_train_data_train_data                         (),                         //              dfe_0_train_data.train_data
		.dfe_0_train_data_train_data_valid                   (),                   //                              .train_data_valid
		.reset_reset_n                                       (reset_n),                                       //                         reset.reset_n
		.pam4_decoder_0_rx_pam4_input_voltage_level_in       (voltage_out_dfe),       //  pam4_decoder_0_rx_pam4_input.voltage_level_in
		.pam4_decoder_0_rx_pam4_input_voltage_level_in_valid (voltage_dfe_valid), //                              .voltage_level_in_valid
		.pam4_decoder_0_rx_pam4_output_symbol_out            (decoder_in),            // pam4_decoder_0_rx_pam4_output.symbol_out
		.pam4_decoder_0_rx_pam4_output_symbol_out_valid      (decoder_valid),      //                              .symbol_out_valid
		.gray_decoder_0_data_out_data_out                    (decoder_out),                    //       gray_decoder_0_data_out.data_out
		.gray_decoder_0_data_out_data_out_valid              (decoder_out_valid),              //                              .data_out_valid
		.gray_decoder_0_symbol_in_symbol_in                  (decoder_in),                  //      gray_decoder_0_symbol_in.symbol_in
		.gray_decoder_0_symbol_in_symbol_in_valid            (decoder_valid)             //                              .symbol_in_valid
	   );
		
		
		
		
		///////////////////////////////////////////////////////////////////control signals to the board////////////////////////////////////////////////////////////
		
		//connecting to button
		assign prbs_en = ~KEY[1]; //
		assign reset_n = KEY[0]; //down = logic 0, up: logic 1
		assign load_mem_pressed = ~KEY[2];
		assign LEDR[0] = done_wait;
		
		//tying off signals:
		assign wen2 = 'b0;
		
		////////////////////////////////////////////////////////////////////controls to PC////////////////////////////////////////////////////
		
		assign uart_rx = HPS_UART_RX;
		assign HPS_UART_TX = uart_tx;
		NIOS_UART u0 (
		.clk_clk                        (clock),                        //                        clk.clk
		.reset_reset_n                  (reset_n),                  //                      reset.reset_n
		.uart_0_external_connection_rxd (uart_rx), // uart_0_external_connection.rxd
		.uart_0_external_connection_txd (uart_tx),  //                           .txd
		//connection to noise
		.on_chip_mem_reset2_reset       (reset_n),       //         on_chip_mem_reset2.reset
		.on_chip_mem_reset2_reset_req   ('b0),   //                           .reset_req
		.on_chip_mem_s2_address         (addr2),         //             on_chip_mem_s2.address
		.on_chip_mem_s2_chipselect      ('b1),      //                           .chipselect
		.on_chip_mem_s2_clken           ('b1),           //                           .clken
		.on_chip_mem_s2_write           (wen2),           //                           .write
		.on_chip_mem_s2_readdata        (readdata2),        //                           .readdata
		.on_chip_mem_s2_writedata       (writedata2),       //                           .writedata
		.on_chip_mem_s2_byteenable      ()       //                           .byteenable
		);

		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
endmodule