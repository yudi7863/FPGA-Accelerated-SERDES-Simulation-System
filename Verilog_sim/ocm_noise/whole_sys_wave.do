onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /whole_sys_tb/binary_data
add wave -noupdate /whole_sys_tb/binary_data_valid
add wave -noupdate /whole_sys_tb/symbol
add wave -noupdate /whole_sys_tb/symbol_valid
add wave -noupdate /whole_sys_tb/voltage_level
add wave -noupdate /whole_sys_tb/voltage_level_valid
add wave -noupdate -divider channel
add wave -noupdate /whole_sys_tb/channel_state
add wave -noupdate /whole_sys_tb/channel_mem_triggered
add wave -noupdate /whole_sys_tb/channel_in_valid
add wave -noupdate /whole_sys_tb/channel_enable
add wave -noupdate /whole_sys_tb/load_mem_c
add wave -noupdate /whole_sys_tb/done_wait_c
add wave -noupdate /whole_sys_tb/voltage_out_channel
add wave -noupdate /whole_sys_tb/voltage_channel_valid
add wave -noupdate -divider noise
add wave -noupdate /whole_sys_tb/noise_state
add wave -noupdate /whole_sys_tb/noise_in_valid_i
add wave -noupdate /whole_sys_tb/noise_in_valid
add wave -noupdate /whole_sys_tb/done_wait_n
add wave -noupdate /whole_sys_tb/load_mem_n
add wave -noupdate /whole_sys_tb/noise_output
add wave -noupdate /whole_sys_tb/noise_valid
add wave -noupdate -divider rx
add wave -noupdate /whole_sys_tb/voltage_level_dfe
add wave -noupdate /whole_sys_tb/voltage_level_dfe_valid
add wave -noupdate /whole_sys_tb/symbol_rx
add wave -noupdate /whole_sys_tb/symbol_rx_valid
add wave -noupdate /whole_sys_tb/binary_data_rx
add wave -noupdate /whole_sys_tb/binary_data_rx_valid
add wave -noupdate /whole_sys_tb/total_bits
add wave -noupdate /whole_sys_tb/total_bit_errors
add wave -noupdate -divider mem
add wave -noupdate /whole_sys_tb/location_n
add wave -noupdate /whole_sys_tb/location_c
add wave -noupdate /whole_sys_tb/mem_data
add wave -noupdate /whole_sys_tb/addr2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3010000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
configure wave -valuecolwidth 65
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
WaveRestoreZoom {0 ps} {5071500 ps}
