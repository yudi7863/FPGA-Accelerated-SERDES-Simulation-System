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
add wave -noupdate -divider Channel
add wave -noupdate /rx_standalone_tb/channel/signal_in
add wave -noupdate /rx_standalone_tb/channel/signal_in_valid
add wave -noupdate /rx_standalone_tb/channel/signal_out
add wave -noupdate /rx_standalone_tb/channel/signal_out_valid
add wave -noupdate /rx_standalone_tb/channel/isi_effect
add wave -noupdate -divider DFE
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_in
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_in_valid
add wave -noupdate /rx_standalone_tb/DecisionFeedback/noise
add wave -noupdate /rx_standalone_tb/DecisionFeedback/train_data
add wave -noupdate /rx_standalone_tb/DecisionFeedback/train_data_valid
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_out
add wave -noupdate /rx_standalone_tb/DecisionFeedback/signal_out_valid
add wave -noupdate /rx_standalone_tb/DecisionFeedback/h_function_vals
add wave -noupdate -radix decimal /rx_standalone_tb/DecisionFeedback/feedback_value
add wave -noupdate -radix decimal /rx_standalone_tb/DecisionFeedback/division
add wave -noupdate -radix decimal /rx_standalone_tb/DecisionFeedback/subtract_result
add wave -noupdate /rx_standalone_tb/DecisionFeedback/buffer
add wave -noupdate -divider dm
add wave -noupdate -radix decimal /rx_standalone_tb/DecisionFeedback/DM/estimation
add wave -noupdate /rx_standalone_tb/DecisionFeedback/DM/e_valid
add wave -noupdate -radix decimal /rx_standalone_tb/DecisionFeedback/DM/feedback_value
add wave -noupdate /rx_standalone_tb/DecisionFeedback/DM/f_valid
add wave -noupdate -radix decimal /rx_standalone_tb/DecisionFeedback/DM/value
add wave -noupdate -radix decimal -childformat {{{/rx_standalone_tb/DecisionFeedback/DM/difference[3]} -radix decimal} {{/rx_standalone_tb/DecisionFeedback/DM/difference[2]} -radix decimal} {{/rx_standalone_tb/DecisionFeedback/DM/difference[1]} -radix decimal} {{/rx_standalone_tb/DecisionFeedback/DM/difference[0]} -radix decimal}} -expand -subitemconfig {{/rx_standalone_tb/DecisionFeedback/DM/difference[3]} {-height 15 -radix decimal} {/rx_standalone_tb/DecisionFeedback/DM/difference[2]} {-height 15 -radix decimal} {/rx_standalone_tb/DecisionFeedback/DM/difference[1]} {-height 15 -radix decimal} {/rx_standalone_tb/DecisionFeedback/DM/difference[0]} {-height 15 -radix decimal}} /rx_standalone_tb/DecisionFeedback/DM/difference
add wave -noupdate /rx_standalone_tb/DecisionFeedback/DM/best_value
add wave -noupdate /rx_standalone_tb/DecisionFeedback/DM/best_difference
add wave -noupdate /rx_standalone_tb/DecisionFeedback/DM/feedback_value_i
add wave -noupdate /rx_standalone_tb/DecisionFeedback/DM/test
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53729 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 333
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
WaveRestoreZoom {0 ps} {636715 ps}
