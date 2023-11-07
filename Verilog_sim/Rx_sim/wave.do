onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /rx_standalone_tb/random_data
add wave -noupdate /rx_standalone_tb/clk
add wave -noupdate /rx_standalone_tb/resetn
add wave -noupdate /rx_standalone_tb/voltage_level
add wave -noupdate /rx_standalone_tb/voltage_level_valid
add wave -noupdate /rx_standalone_tb/voltage_level_isi
add wave -noupdate /rx_standalone_tb/signal_valid
add wave -noupdate /rx_standalone_tb/no_isi
add wave -noupdate /rx_standalone_tb/no_isi_valid
add wave -noupdate /rx_standalone_tb/shift_data
add wave -noupdate /rx_standalone_tb/count
add wave -noupdate /rx_standalone_tb/rstn
add wave -noupdate -divider channel
add wave -noupdate /rx_standalone_tb/channel/signal_in
add wave -noupdate /rx_standalone_tb/channel/signal_in_valid
add wave -noupdate /rx_standalone_tb/channel/signal_out
add wave -noupdate /rx_standalone_tb/channel/signal_out_valid
add wave -noupdate /rx_standalone_tb/channel/convolution_result
add wave -noupdate /rx_standalone_tb/channel/isi_result
add wave -noupdate /rx_standalone_tb/channel/shift_reg
add wave -noupdate -divider DFE
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_in
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_in_valid
add wave -noupdate /rx_standalone_tb/DecisionFeedback/noise
add wave -noupdate /rx_standalone_tb/DecisionFeedback/train_data
add wave -noupdate /rx_standalone_tb/DecisionFeedback/train_data_valid
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_out
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_out_valid
add wave -noupdate /rx_standalone_tb/DecisionFeedback/h_function_vals
add wave -noupdate /rx_standalone_tb/DecisionFeedback/feedback_value
add wave -noupdate /rx_standalone_tb/DecisionFeedback/subtract_result
add wave -noupdate /rx_standalone_tb/DecisionFeedback/estimation
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {270000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 281
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {721079 ps}
