`timescale 1ns / 1ps
module whole_sys_tb;
 /////////////////////////noise related signals///////////////////////////////
    //signals:
    logic clk;
    logic en;
    logic rstn;
    logic signed [7:0] noise_in;
    logic nvalid;
    logic valid;
    //controls for noise:
    logic done_wait_n;
    logic [7:0] location_n;
    logic  load_mem_n;
    //controls for channel
     logic done_wait_c;
    logic [7:0] location_c;
    logic  load_mem_c;
    //clk:
    always #10 clk = ~clk;

    //////////////////////////ocm related signals///////////////////////////////////
    //32 bits
    logic [14:0] addr;
    logic wen;
    logic [31:0] writedata;
    logic [31:0] readdata;
    //64 bits
    logic [13:0] addr2;
    logic wen2;
    logic [63:0] writedata2;

    //others:
    logic en2;
    logic [1:0] noise_state, channel_state;
	logic load_mem_pressed, channel_mem_triggered;
    ///////////////////////////////////control logic//////////////////////////////////
    
    
    always_ff @(posedge clk) begin
        if(!rstn) begin 
            location_n <= 'b0;
            location_c <= 'b0;
        end
        else begin
            if (load_mem_n && !wen2) begin
                location_n <= location_n + 1;
            end
            if (load_mem_c && !wen2) begin
                location_c <= location_c + 1;
            end
        end
    end


    always_ff @(posedge clk) begin
        if(!rstn) begin addr2 <= 'b0;
        addr <= 'b0;
        end
        else begin
            if(en2 && !done_wait_n && load_mem_n) begin
                if(addr2 == 'h1fc) addr2 <= 'h1fc;
                else addr2 <= addr2 + 4;
            end
            else if(en2 && !done_wait_c && channel_mem_triggered) begin
                if(addr2 == 'h210) addr <= 'h210;
                else addr2 <= addr2 + 4;
            end
            else addr2 <= addr2;
        end
    end

    //////////////////////////////////////////TX ///////////////////////////////////////////////
    wire binary_data;
    wire binary_data_valid;
    prbs31 prbs(
        .clk(clk),
        .rstn(rstn),
        .en(en),
        .data_out(binary_data),
        .data_out_valid(binary_data_valid));
    
    // Generate grey-coded PAM-4 symbols
    wire [1:0] symbol;
    wire symbol_valid;
    grey_encode ge(
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data),
	    .data_in_valid(binary_data_valid),
        .symbol_out(symbol),
        .symbol_out_valid(symbol_valid));

    // Generate voltage levels
    wire [7:0] voltage_level;
    wire voltage_level_valid;
    pam_4_encode #(.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) pe(
        .clk(clk),
        .rstn(rstn),
        .symbol_in(symbol),
	    .symbol_in_valid(symbol_valid),
        .voltage_level_out(voltage_level),
        .voltage_level_out_valid(voltage_level_valid));
    logic [7:0] voltage_out_channel;
    logic voltage_channel_valid;
    //modified channel:
    /*ISI_channel channel (
        .clk(clk),
        .rstn(rstn),
        .signal_in(voltage_level),
        .signal_in_valid(voltage_level_valid),
        .signal_out(voltage_out_channel),
        .signal_out_valid(voltage_channel_valid));*/


    ////////////////////////////////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////noise instantiation////////////////////////////////////////////////////////////
		logic signed [7:0] noise_output;
        logic noise_valid;
		
		//need to modify this for the reading and writing into the ocm:
		
		logic noise_enable;
		logic noise_in_valid_i;
		logic noise_in_valid;
		
		parameter WAIT_MEM = 2'b00, LOAD_MEM = 2'b01, DONE_WAIT = 2'b10;

		always_ff @(posedge clk) begin
			if(!rstn) begin
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
										noise_enable <= en; //en should be prbs enable?
										noise_in_valid_i <= voltage_channel_valid;
										noise_state <= DONE_WAIT;
								end
								else noise_state <= LOAD_MEM;
								end
					DONE_WAIT: begin noise_state <= DONE_WAIT; //triggers the load_mem for channel:
								   noise_enable <= en;
									noise_in_valid_i <= voltage_channel_valid;
                                    channel_mem_triggered <= 'b1;
									end
					default: noise_state <= noise_state;
				endcase
			end
		end


        ////////////////////fsm for channel
        //connective signals:
        logic channel_enable;
        logic channel_in_valid;
		always_ff @(posedge clk) begin
			if(!rstn) begin
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
										channel_enable <= en;
                                        channel_in_valid <= voltage_level_valid; //from the PAM-4
										channel_state <= DONE_WAIT;
								end
								else channel_state <= LOAD_MEM;
								end
					DONE_WAIT: begin channel_state <= DONE_WAIT; //triggers the load_mem for channel:
                                     channel_enable <= en;
                                     channel_in_valid <= voltage_level_valid; //from the PAM-4
									end
					default: channel_state <= WAIT_MEM;
				endcase
			end
		end


        //connecting valid signals for noise and for channel:
        //channel
       /* logic channel_in_valid;
        always_ff @ (posedge clk) begin
			if(!rstn) channel_in_valid <= 'b0;
			else begin
				if(channel_in_valid_i) begin
					channel_in_valid <= 'b1;
				end
				else channel_in_valid <= channel_in_valid;
			end
		end*/

        //noise
		always_ff @ (posedge clk) begin
			if(!rstn) noise_in_valid <= 'b0;
			else begin
				if(noise_in_valid_i) begin
					noise_in_valid <= 'b1;
				end
				else noise_in_valid <= noise_in_valid;
			end
		end
		///probablemattic readdata2: inverted ??
		logic [63:0] mem_data;


        ISI_channel_ocm channel (
        .clk(clk),
        .rstn(rstn),
        .signal_in(voltage_level),
        .signal_in_valid(voltage_level_valid),
        .signal_out(voltage_out_channel),
        .signal_out_valid(voltage_channel_valid),
         //added control ports:
        .load_mem(load_mem_c),
        .done_wait(done_wait_c),
        .location(location_c),
        .mem_data(mem_data)); //this needs to be changed

        wire [7:0] noise_counter[127:0];
		//assign noise_data = {readdata2[31:0],readdata2[63:32]};
		noise_128_wrapper noise_wrapper_noise (
            .clk(clk),
            .en(en), //yudi: need to change this later
            .rstn(rstn),
            .noise_in(voltage_out_channel),
			.noise_in_valid(voltage_channel_valid),
            .noise_out(noise_output),
            .noise_out_valid(noise_valid),
			.done_wait(done_wait_n), //////for loading signals
			.mem_data(mem_data),
			.location(location_n),
			.load_mem(load_mem_n),
            .noise_counter(noise_counter)
    );


     //dut:
    NIOS_UART_on_chip_mem ocm(
// inputs:
        //port 1: 32 bits:
        .address(addr),
        .byteenable(), //selecting bytes
        .chipselect('b1), // must be 1
        .clk(clk),
        .clken('b1), //enable clk
        .freeze('b0),
        .reset(~rstn),
        .reset_req('b0), 
        .write(wen),
        .writedata(writedata),
        //port2: 64 bits:
        .address2(addr2),
        .byteenable2(), //selecting bytes
        .chipselect2('b1), // must be 1
        .clk2(clk),
        .clken2('b1), //enable clk
        .reset2(~rstn),
        .reset_req2('b0), 
        .write2(wen2),
        .writedata2(writedata2),

        // outputs:
        .readdata(readdata),
        .readdata2(mem_data)

    );
    
    wire [7:0] voltage_level_dfe;
    wire voltage_level_dfe_valid;
    DFE #(.PULSE_RESPONSE_LENGTH(2), .SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) rx(
        .clk(clk),
        .rstn(rstn),
        .signal_in(noise_output),
        .signal_in_valid(noise_valid),
        .signal_out(voltage_level_dfe),
        .signal_out_valid(voltage_level_dfe_valid));

    wire [1:0] symbol_rx;
    wire symbol_rx_valid;
    pam_4_decode #(.SIGNAL_RESOLUTION(8), .SYMBOL_SEPERATION(56)) pd(
        .clk(clk),
        .rstn(rstn),
        .voltage_level_in(voltage_level_dfe),
	    .voltage_level_in_valid(voltage_level_dfe_valid),
        .symbol_out(symbol_rx),
        .symbol_out_valid(symbol_rx_valid));

    wire binary_data_rx;
    wire binary_data_rx_valid;
    grey_decode gd(
        .clk(clk),
        .rstn(rstn),
        .symbol_in(symbol_rx),
	    .symbol_in_valid(symbol_rx_valid),
        .data_out(binary_data_rx),
        .data_out_valid(binary_data_rx_valid));

    wire [31:0] total_bits;
    wire [31:0] total_bit_errors;
    prbs31_checker ebr(
        .clk(clk),
        .rstn(rstn),
        .data_in(binary_data_rx),
        .data_in_valid(binary_data_rx_valid),
        .total_bits(total_bits),
        .total_bit_errors(total_bit_errors));




    initial begin
            //control mem to write
            //wait for done_wait to be asserted
            //start noise operation
        clk <= 'b0;
        rstn <= 'b0;
        noise_in <= 'b0;
        nvalid <= 'b0;
        load_mem_pressed <= 'b0;
        en <= 'b0;
        wen = 'b0;
        wen2 = 'b0;
        #20
        rstn <= 1;
        //load_mem_pressed <= 'b1;
        en2 = 'b1;
        #20
        load_mem_pressed <= 'b1;
         #20
         load_mem_pressed <= 'b0;
        //rstn <= 1;
        //en2 = 'b1;
       // load_mem <= 1;
        wait(done_wait_c);
        //load_mem <= 0;
        en <= 'b1;
        nvalid <= 1;
        #1000000

        $display("\nBits Transmitted:%d", total_bits);
        $display("\nBit Errors:%d", total_bit_errors);

        for (int i = 0; i < 128; i = i + 1) begin
            $display("noise_counter[%0d] = %d", i, noise_counter[i]);
        end
        $finish();

    end
endmodule