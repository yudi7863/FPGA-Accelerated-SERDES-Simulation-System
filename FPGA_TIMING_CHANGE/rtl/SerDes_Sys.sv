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
		logic done_wait_n;
		logic [7:0] location_n;
		logic  load_mem_n;
		logic load_mem_pressed;
		 //controls for channel
		 logic done_wait_c;
		 logic [7:0] location_c;
		 logic load_mem_c;
		 logic channel_mem_triggered;
		
		//on-chip-ram connection -> connect to UART:
		 logic [13:0] addr2 /*synthesis preserve*/;
		 logic wen2;
		 logic [63:0] writedata2;
		 logic [63:0] readdata2;
		 //prbs_checker:
		 logic [70:0] counter_samples;
		
		
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
		
		//assign clock = CLOCK_50;
		
		//counter for number of symbols:
		
		
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
		////////////////////////////////////////////////////////////////channel///////////////////////////////////////////////////////////////////
		/*channel channel_model (
		.clk_clk                                          (clock),                                          //                             clk.clk
		.reset_reset_n                                    (reset_n),                                    //                           reset.reset_n
		.channel_module_0_channel_input_signal_in         (voltage_out),         //  channel_module_0_channel_input.signal_in
		.channel_module_0_channel_input_signal_in_valid   (voltage_valid),   //                                .signal_in_valid
		.channel_module_0_channel_output_signal_out       (voltage_out_channel),       // channel_module_0_channel_output.signal_out
		.channel_module_0_channel_output_signal_out_valid (voltage_channel_valid)  //                                .signal_out_valid
	   );
		*/
			//channel related control signals and fsm:
		logic [1:0] channel_state;
		logic channel_enable;
		logic channel_in_valid;
		always_ff @(posedge clock) begin
			if(!reset_n) begin
				channel_enable <= 'b0;
            channel_in_valid <= 'b0;
			end
			else begin
				case(channel_state)
					WAIT_MEM: begin if (channel_mem_triggered) begin
										load_mem_c <= 'b1;
                              //channel_mem_triggered <= 'b0;
										channel_state <= LOAD_MEM;
								 end
								 else begin
									load_mem_c <= 1'b0;
									channel_state <= WAIT_MEM;
								end
								end
					LOAD_MEM: begin if(done_wait_c) begin
										load_mem_c <= 'b0;
										channel_enable <= prbs_en;
                              channel_in_valid <= voltage_valid; //from the PAM-4
										channel_state <= DONE_WAIT;
								end
								else channel_state <= LOAD_MEM;
								end
					DONE_WAIT: begin channel_state <= DONE_WAIT; //triggers the load_mem for channel:
									 channel_enable <= prbs_en;
									 channel_in_valid <= voltage_valid; //from the PAM-4
									end
					default: channel_state <= WAIT_MEM;
				endcase
			end
		end
			
			
		logic [63:0] pulse_data;
		assign pulse_data = {readdata2[31:0],readdata2[63:32]};
		 ISI_channel_ocm  #(.PULSE_RESPONSE_LENGTH(2),.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) channel (
        .clk(clock),
        .rstn(reset_n),
		  //inputs
        .signal_in(voltage_out),
        .signal_in_valid(voltage_valid),
		  //outputs
        .signal_out(voltage_out_channel),
        .signal_out_valid(voltage_channel_valid),
         //added control ports:
        .load_mem(load_mem_c),
        .done_wait(done_wait_c),
        .location(location_c),
        .mem_data(pulse_data)); //this needs to be changed
		
		///////////////////////////////////////////////////////////noise instantiation////////////////////////////////////////////////////////////
		
		logic [7:0] noise_output;
      logic noise_valid;
		//control signal reset for all (?)
		always_ff @(posedge clock) begin
        if(!reset_n) begin 
            location_n <= 7'b0;
            location_c <= 7'b0;
        end
        else begin
            if (load_mem_n && !wen2) begin
                location_n <= location_n + 7'b1;
            end
            if (load_mem_c && !wen2) begin
                location_c <= location_c + 7'b1;
            end
        end
		end
		logic prbs_en_control;
		logic load_mem_control;
		always_ff @(posedge clock) begin
        if(!reset_n) begin //8A0
				addr2 <= 14'h2d0; //this offset it to wait for loadmem instruction, need to start at an offset, the front are designed for ocm to load in uart std lib files
				wen2 <= 'b0;
				prbs_en_control <= 'b0;
				load_mem_control <= 'b1; //need to load mem
				prbs_en <= 'b0;
				load_mem_pressed <= 'b0;
				
			end
        else begin
				if(load_mem_control) begin
					if(readdata2[0] == 1'b1) begin
						load_mem_pressed <= 1'b1;
						load_mem_control <= 1'b0;
						addr2 <= 14'h1B0; //this is the address of the noise/channel values
					end
					else addr2 <= 14'h2d0; //location of load_mem controls and prbs_en
				end
				else if(load_mem_c & !prbs_en_control) begin
					prbs_en_control <= 1'b1;
				end
				else if(prbs_en_control) begin
					addr2 <= 14'h2d0;
					if(readdata2[1] == 1'b1) begin
						prbs_en <= 1'b1;
						prbs_en_control <= 1'b0;
					end
				end
				
				//also need to look for prbs_en
            if(!done_wait_n && load_mem_n) begin
					if(addr2 == 'h2B0) addr2 <= 14'h2B0;
               else addr2 <= addr2 + 14'd2;
            end
				else if (!done_wait_c && load_mem_c) begin
					//if(addr2 == 'h104) addr2 <= 'h104;
               /*else*/ addr2 <= addr2 + 14'd2;
				end
            else begin
					if(counter_samples >= 'h7A1200 && counter_samples < 'h7A1201) begin //4000 = 'hFA0
						addr2 <= 14'h2c0; //0580 in hex mem
						writedata2 <= counter_samples;
						wen2 <= 'b1;
					end 
					else if(counter_samples >= 'h7A1201 && counter_samples < 'h7A1202) begin
						addr2 <= addr2 + 'd2; //0580 in hex mem
						writedata2 <= total_bit_errors;
						wen2 <= 'b1;
					end
					else begin
						wen2 <= 1'b0;
						writedata2 <= 'b0;
					end
					
				end
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
		logic [1:0] noise_state;
		
		always_ff @(posedge clock) begin
			if(!reset_n) begin
				noise_state = WAIT_MEM;
				noise_enable <= 'b0;
				noise_in_valid_i <= 'b0;
				channel_mem_triggered <= 'b0; 
			end
			else begin
				case(noise_state)
					WAIT_MEM: begin if (load_mem_pressed) begin
										load_mem_n <= 'b1;
										noise_state <= LOAD_MEM;
								 end
								 else begin
									load_mem_n <= 1'b0;
									noise_state <= WAIT_MEM;
								end
								end
					LOAD_MEM: begin if(done_wait_n) begin
										load_mem_n <= 'b0;
										noise_enable <= prbs_en;
										noise_in_valid_i <= voltage_channel_valid;
										noise_state <= DONE_WAIT;
								end
								else noise_state <= LOAD_MEM;
								end
					DONE_WAIT: begin noise_state <= DONE_WAIT; //can technically put prbs_en here
								   noise_enable <= prbs_en;
									noise_in_valid_i <= voltage_channel_valid;
									channel_mem_triggered <= 'b1;
									end
					default: noise_state <= WAIT_MEM;
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
		logic [7:0] noise_out_hex;
		noise_128_wrapper noise_wrapper_noise (
            .clk(clock),
            .en(prbs_en && !load_mem_n), //yudi: need to change this later
            .rstn(reset_n),
            .noise_in(voltage_out_channel),
				.noise_in_valid(voltage_channel_valid),//noise_in_valid),
            .noise_out(noise_output),
            .noise_out_valid(noise_valid),
				.done_wait(done_wait_n), //////for loading signals
			   .mem_data(noise_data),
			   .location(location_n),
			   .load_mem(load_mem_n)
    );
	 
	 		/*noise_128_wrapper_mem noise_wrapper_noise_mem (
            .clk(clock),
            .en(prbs_en), //yudi: need to change this later
            .rstn(reset_n),
            .noise_in(voltage_out_channel),
				.noise_in_valid(voltage_channel_valid),//noise_in_valid),
            .noise_out(noise_output),
            .noise_out_valid(noise_valid)
    );*/
		logic done_wait_d;
		DFE_prl #(.PULSE_RESPONSE_LENGTH(2),.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56))DFE(
		.done_wait                           (done_wait_d),                           //               dfe_0_done_wait.done_wait
		.load_mem                             (load_mem_c),                             //                dfe_0_load_mem.load_mem
		.mem_data                             (pulse_data),                             //                dfe_0_mem_data.mem_data
		.location                             (location_c),                             //                dfe_0_location.location
		.signal_in                           (noise_output),                           //               dfe_0_signal_in.signal_in
		.signal_in_valid                     (noise_valid),                     //                              .signal_in_valid
		.signal_out                         (voltage_out_dfe),                         //              dfe_0_signal_out.signal_out
		.signal_out_valid                   (voltage_dfe_valid),
		.clk(clock),
		.rstn(reset_n));                  //                              .signal_out_valid
		
		
		logic data_out;
		logic data_out_valid;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*RX receiver (
		.clk_clk                                             (clock),                                             //                           clk.clk                    //                              .signal_out_valid
		//                              .train_data_valid
		.reset_reset_n                                       (reset_n),                                       //                         reset.reset_n
		.pam4_decoder_0_rx_pam4_input_voltage_level_in       (voltage_out_dfe),       //  pam4_decoder_0_rx_pam4_input.voltage_level_in
		.pam4_decoder_0_rx_pam4_input_voltage_level_in_valid (voltage_dfe_valid), //                              .voltage_level_in_valid
		.pam4_decoder_0_rx_pam4_output_symbol_out            (decoder_in),            // pam4_decoder_0_rx_pam4_output.symbol_out
		.pam4_decoder_0_rx_pam4_output_symbol_out_valid      (decoder_valid),      //                              .symbol_out_valid
		.gray_decoder_0_data_out_data_out                    (data_out),                    //       gray_decoder_0_data_out.data_out
		.gray_decoder_0_data_out_data_out_valid              (data_out_valid),              //                              .data_out_valid
		.gray_decoder_0_symbol_in_symbol_in                  (decoder_in),                  //      gray_decoder_0_symbol_in.symbol_in
		.gray_decoder_0_symbol_in_symbol_in_valid            (decoder_valid)             //                              .symbol_in_valid
	   );*/
		
		pam_4_decode #(.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) pd(
        .clk(clock),
        .rstn(reset_n),
        .voltage_level_in(voltage_out_dfe),
	    .voltage_level_in_valid(voltage_dfe_valid),
        .symbol_out(decoder_in),
        .symbol_out_valid(decoder_valid));

    
		grey_decode gd(
        .clk(clock),
        .rstn(reset_n),
        .symbol_in(decoder_in),
	    .symbol_in_valid(decoder_valid),
        .data_out(data_out),
        .data_out_valid(data_out_valid));
		
	  wire [31:0] total_bits;
			wire [31:0] total_bit_errors;
	   /* prbs31_checker checker ( //for some reason, enabling this module causes timing violations
			.clk(clock),
			.rstn(reset_n),
			.data_in(data_out),
			.data_in_valid(data_out_valid),

			.total_bits(total_bits),
			.total_bit_errors(total_bit_errors)
		 );*/
		 //we can latch the prbs input to match with output?
		 localparam SEED = 31'b1101000101011010010010100011111;
		 reg [30:0] sr = SEED;
		 wire sr_in;
		assign sr_in = (sr[30]^sr[27]);
		
		
		always @ (posedge clock) begin
			 if (!reset_n) begin
				  sr = SEED;
				  counter_samples <= 'b0;
				  total_bit_errors = 'b0;
				  LEDR[6] <= 'b0;
			 end else begin
					LEDR[6] <= (counter_samples >=  'h2faf0800);//'h2faf0800);
				  if (data_out_valid) begin
						sr <= {sr[29:0],sr_in};
						counter_samples <= counter_samples + 1;
						if (data_out != sr_in) begin
							 total_bit_errors <= total_bit_errors + 1;
						end
				  end
			 end
	 end
	 
	 
	 /*logic [12:0] latched_input;
    //logic [4:0] cnt;
    logic correct_or_not;
    always_ff @ (posedge clock) begin
        if(!reset_n) begin
            latched_input <= 'b0;
            //cnt <= 'b0;
            //correct_or_not <= 'b0;
            counter_samples <= 'b0;
            total_bit_errors <= 'b0;
        end
        if(prbs_valid) begin
            //latched_input[cnt] <= binary_data;
            //latched_input[11] <= binary_data;
            for(int i = 11; i > 0; i = i - 1) begin
                if(i < 11 ) latched_input[i] <= latched_input [i+1];
                if(i == 11) latched_input[i] <= binary_data;
            end
        end
        if(data_out_valid) begin
                counter_samples <= counter_samples + 1;
                //correct_or_not <= (latched_input[1] == binary_data_rx);
        end
		if(!correct_or_not && data_out_valid) total_bit_errors <= total_bit_errors + 1;
    end

    assign correct_or_not = (data_out_valid) ? (latched_input[1] == data_out) : 'b0;*/

		///////////////////////////////////////////////////////////////////control signals to the board////////////////////////////////////////////////////////////
		
		//connecting to button
		//assign prbs_en = ~KEY[1]; //
		assign reset_n = KEY[0]; //down = logic 0, up: logic 1
		//assign load_mem_pressed = ~KEY[2];
		assign LEDR[0] = done_wait_c;
		///using uart to program the FPGA:
		//tying off signals:
		//assign wen2 = 'b0;
		
		////////////////////////////////////////////////////////////////////controls to PC////////////////////////////////////////////////////
		//add logic to get bit error rate and output to uart:
		
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
		.on_chip_mem_s2_byteenable      ('hFF)       //                           .byteenable
		);

		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
endmodule
