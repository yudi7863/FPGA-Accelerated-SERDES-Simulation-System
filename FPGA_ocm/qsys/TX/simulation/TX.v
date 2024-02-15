// TX.v

// Generated using ACDS version 22.1 922

`timescale 1 ps / 1 ps
module TX (
		input  wire       clk_clk,                                                 //                             clk.clk
		input  wire       gray_encoder_0_data_in_data_in,                          //          gray_encoder_0_data_in.data_in
		input  wire       gray_encoder_0_data_in_data_in_valid,                    //                                .data_in_valid
		output wire [1:0] gray_encoder_0_symbol_out_symbol_out,                    //       gray_encoder_0_symbol_out.symbol_out
		output wire       gray_encoder_0_symbol_out_symbol_out_valid,              //                                .symbol_out_valid
		input  wire [1:0] pam_encoder_0_symbol_in_symbol_in,                       //         pam_encoder_0_symbol_in.symbol_in
		input  wire       pam_encoder_0_symbol_in_symbol_in_valid,                 //                                .symbol_in_valid
		output wire [7:0] pam_encoder_0_voltage_level_out_voltage_level_out,       // pam_encoder_0_voltage_level_out.voltage_level_out
		output wire       pam_encoder_0_voltage_level_out_voltage_level_out_valid, //                                .voltage_level_out_valid
		output wire       prbs_0_data_out_data_out,                                //                 prbs_0_data_out.data_out
		output wire       prbs_0_data_out_data_out_valid,                          //                                .data_out_valid
		input  wire       prbs_0_prbs_ctrl_en,                                     //                prbs_0_prbs_ctrl.en
		input  wire       reset_reset_n                                            //                           reset.reset_n
	);

	wire    rst_controller_reset_out_reset; // rst_controller:reset_out -> [PAM_encoder_0:rstn, gray_encoder_0:rstn, prbs_0:rstn]

	TX_PAM_encoder_0 pam_encoder_0 (
		.clk                     (clk_clk),                                                 //             clock.clk
		.rstn                    (~rst_controller_reset_out_reset),                         //              rstn.reset_n
		.symbol_in               (pam_encoder_0_symbol_in_symbol_in),                       //         symbol_in.symbol_in
		.symbol_in_valid         (pam_encoder_0_symbol_in_symbol_in_valid),                 //                  .symbol_in_valid
		.voltage_level_out       (pam_encoder_0_voltage_level_out_voltage_level_out),       // Voltage_level_out.voltage_level_out
		.voltage_level_out_valid (pam_encoder_0_voltage_level_out_voltage_level_out_valid)  //                  .voltage_level_out_valid
	);

	TX_gray_encoder_0 gray_encoder_0 (
		.clk              (clk_clk),                                    //      clock.clk
		.data_in          (gray_encoder_0_data_in_data_in),             //    data_in.data_in
		.data_in_valid    (gray_encoder_0_data_in_data_in_valid),       //           .data_in_valid
		.symbol_out       (gray_encoder_0_symbol_out_symbol_out),       // symbol_out.symbol_out
		.symbol_out_valid (gray_encoder_0_symbol_out_symbol_out_valid), //           .symbol_out_valid
		.rstn             (~rst_controller_reset_out_reset)             //       rstn.reset_n
	);

	TX_prbs_0 prbs_0 (
		.clk            (clk_clk),                         //     clock.clk
		.rstn           (~rst_controller_reset_out_reset), //      rstn.reset_n
		.data_out       (prbs_0_data_out_data_out),        //  data_out.data_out
		.data_out_valid (prbs_0_data_out_data_out_valid),  //          .data_out_valid
		.en             (prbs_0_prbs_ctrl_en)              // prbs_ctrl.en
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                 // reset_in0.reset
		.clk            (clk_clk),                        //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_in1      (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

endmodule
