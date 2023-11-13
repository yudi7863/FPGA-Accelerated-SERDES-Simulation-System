// RX.v

// Generated using ACDS version 22.1 922

`timescale 1 ps / 1 ps
module RX (
		input  wire       clk_clk,                           //              clk.clk
		input  wire [7:0] dfe_0_dfe_in_signal_in,            //     dfe_0_dfe_in.signal_in
		input  wire       dfe_0_dfe_in_signal_in_valid,      //                 .signal_in_valid
		output wire [7:0] dfe_0_dfe_out_signal_out,          //    dfe_0_dfe_out.signal_out
		output wire       dfe_0_dfe_out_signal_out_valid,    //                 .signal_out_valid
		input  wire [7:0] dfe_0_noise_noise,                 //      dfe_0_noise.noise
		input  wire [7:0] dfe_0_train_data_train_data,       // dfe_0_train_data.train_data
		input  wire       dfe_0_train_data_train_data_valid, //                 .train_data_valid
		input  wire       reset_reset_n                      //            reset.reset_n
	);

	wire    rst_controller_reset_out_reset; // rst_controller:reset_out -> dfe_0:rstn

	DFE #(
		.PULSE_RESPONSE_LENGTH (2),
		.SIGNAL_RESOLUTION     (8),
		.SYMBOL_SEPERATION     (56)
	) dfe_0 (
		.clk              (clk_clk),                           //      clock.clk
		.rstn             (~rst_controller_reset_out_reset),   //    reset_n.reset_n
		.noise            (dfe_0_noise_noise),                 //      noise.noise
		.train_data       (dfe_0_train_data_train_data),       // train_data.train_data
		.train_data_valid (dfe_0_train_data_train_data_valid), //           .train_data_valid
		.signal_in        (dfe_0_dfe_in_signal_in),            //     dfe_in.signal_in
		.signal_in_valid  (dfe_0_dfe_in_signal_in_valid),      //           .signal_in_valid
		.signal_out       (dfe_0_dfe_out_signal_out),          //    dfe_out.signal_out
		.signal_out_valid (dfe_0_dfe_out_signal_out_valid)     //           .signal_out_valid
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