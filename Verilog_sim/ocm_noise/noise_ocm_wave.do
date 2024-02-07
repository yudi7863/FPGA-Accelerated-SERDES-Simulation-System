onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /noise_ocm_tb/clk
add wave -noupdate /noise_ocm_tb/en
add wave -noupdate /noise_ocm_tb/rstn
add wave -noupdate /noise_ocm_tb/noise_in
add wave -noupdate /noise_ocm_tb/nvalid
add wave -noupdate /noise_ocm_tb/valid
add wave -noupdate /noise_ocm_tb/noise_out
add wave -noupdate /noise_ocm_tb/done_wait
add wave -noupdate /noise_ocm_tb/location
add wave -noupdate /noise_ocm_tb/load_mem
add wave -noupdate /noise_ocm_tb/addr
add wave -noupdate /noise_ocm_tb/wen
add wave -noupdate /noise_ocm_tb/writedata
add wave -noupdate /noise_ocm_tb/readdata
add wave -noupdate /noise_ocm_tb/addr2
add wave -noupdate /noise_ocm_tb/wen2
add wave -noupdate /noise_ocm_tb/writedata2
add wave -noupdate /noise_ocm_tb/readdata2
add wave -noupdate /noise_ocm_tb/en2
add wave -noupdate -divider noise
add wave -noupdate /noise_ocm_tb/dut/noise_128/noise_out
add wave -noupdate /noise_ocm_tb/dut/noise_128/noise_out_valid
add wave -noupdate /noise_ocm_tb/dut/noise_128/done_wait
add wave -noupdate /noise_ocm_tb/dut/noise_128/mem_data
add wave -noupdate /noise_ocm_tb/dut/noise_128/location
add wave -noupdate /noise_ocm_tb/dut/noise_128/load_mem
add wave -noupdate /noise_ocm_tb/dut/noise_128/random
add wave -noupdate /noise_ocm_tb/dut/noise_128/random_valid
add wave -noupdate /noise_ocm_tb/dut/noise_128/possibilities
add wave -noupdate /noise_ocm_tb/dut/noise_128/noise_value
add wave -noupdate /noise_ocm_tb/dut/noise_128/i
add wave -noupdate /noise_ocm_tb/dut/noise_128/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2870000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
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
WaveRestoreZoom {452024 ps} {4828841 ps}
