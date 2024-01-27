onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /noise_feedback_tb/clk
add wave -noupdate /noise_feedback_tb/en
add wave -noupdate /noise_feedback_tb/rstn
add wave -noupdate /noise_feedback_tb/binary_data
add wave -noupdate /noise_feedback_tb/binary_data_valid
add wave -noupdate /noise_feedback_tb/symbol
add wave -noupdate /noise_feedback_tb/symbol_valid
add wave -noupdate /noise_feedback_tb/voltage_level
add wave -noupdate /noise_feedback_tb/voltage_level_valid
add wave -noupdate -radix decimal /noise_feedback_tb/voltage_level_isi
add wave -noupdate /noise_feedback_tb/voltage_level_isi_valid
add wave -noupdate -radix decimal /noise_feedback_tb/noise_output
add wave -noupdate /noise_feedback_tb/noise_valid
add wave -noupdate -radix decimal /noise_feedback_tb/voltage_level_dfe
add wave -noupdate /noise_feedback_tb/voltage_level_dfe_valid
add wave -noupdate /noise_feedback_tb/symbol_rx
add wave -noupdate /noise_feedback_tb/symbol_rx_valid
add wave -noupdate /noise_feedback_tb/binary_data_rx
add wave -noupdate /noise_feedback_tb/binary_data_rx_valid
add wave -noupdate -divider noise
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/simple_noise/noise_out
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/simple_noise/noise_out_valid
add wave -noupdate -radix hexadecimal /noise_feedback_tb/noise_wrapper_noise/simple_noise/random
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/simple_noise/random_valid
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/simple_noise/possibilities
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/noise_in
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/noise_out
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/noise_out_valid
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/temp
add wave -noupdate /noise_feedback_tb/noise_wrapper_noise/temp_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {61524 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 402
configure wave -valuecolwidth 209
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {444742 ps}
