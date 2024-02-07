onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /noise_128_tb/clk
add wave -noupdate /noise_128_tb/en
add wave -noupdate /noise_128_tb/rstn
add wave -noupdate /noise_128_tb/noise_in
add wave -noupdate /noise_128_tb/nvalid
add wave -noupdate /noise_128_tb/valid
add wave -noupdate /noise_128_tb/noise_out
add wave -noupdate /noise_128_tb/done_wait
add wave -noupdate /noise_128_tb/mem_data
add wave -noupdate /noise_128_tb/location
add wave -noupdate /noise_128_tb/load_mem
add wave -noupdate /noise_128_tb/set_data
add wave -noupdate /noise_128_tb/j
add wave -noupdate -divider innoise
add wave -noupdate /noise_128_tb/nvalid
add wave -noupdate /noise_128_tb/dut/noise_128/rstn
add wave -noupdate /noise_128_tb/dut/noise_128/noise_out
add wave -noupdate /noise_128_tb/dut/noise_128/noise_out_valid
add wave -noupdate /noise_128_tb/dut/noise_128/done_wait
add wave -noupdate /noise_128_tb/dut/noise_128/mem_data
add wave -noupdate /noise_128_tb/dut/noise_128/location
add wave -noupdate /noise_128_tb/dut/noise_128/load_mem
add wave -noupdate /noise_128_tb/dut/noise_128/random
add wave -noupdate /noise_128_tb/dut/noise_128/random_valid
add wave -noupdate /noise_128_tb/dut/noise_128/possibilities
add wave -noupdate /noise_128_tb/dut/noise_128/noise_value
add wave -noupdate /noise_128_tb/dut/noise_128/i
add wave -noupdate /noise_128_tb/dut/noise_128/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3050000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 276
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1083871 ps} {4571626 ps}
