onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /prbs_pam_4_tb/clk
add wave -noupdate /prbs_pam_4_tb/en
add wave -noupdate /prbs_pam_4_tb/rstn
add wave -noupdate -divider {prbs output}
add wave -noupdate /prbs_pam_4_tb/binary_data
add wave -noupdate /prbs_pam_4_tb/binary_data_valid
add wave -noupdate -divider {gray_code encode}
add wave -noupdate /prbs_pam_4_tb/symbol
add wave -noupdate /prbs_pam_4_tb/symbol_valid
add wave -noupdate -divider {PAM-4 output}
add wave -noupdate /prbs_pam_4_tb/voltage_level
add wave -noupdate /prbs_pam_4_tb/voltage_level_valid
add wave -noupdate -divider {gray_code decode}
add wave -noupdate /prbs_pam_4_tb/symbol_returned
add wave -noupdate /prbs_pam_4_tb/symbol_returned_valid
add wave -noupdate -divider {prbs checker}
add wave -noupdate /prbs_pam_4_tb/binary_data_returned
add wave -noupdate /prbs_pam_4_tb/binary_data_returned_valid
add wave -noupdate -divider {bit error rate calculation}
add wave -noupdate /prbs_pam_4_tb/total_bits
add wave -noupdate /prbs_pam_4_tb/total_bit_errors
add wave -noupdate -divider {matlab verification}
add wave -noupdate /prbs_pam_4_tb/matlab_PAM4
add wave -noupdate /prbs_pam_4_tb/matlab_PAM4_ref
add wave -noupdate /prbs_pam_4_tb/i
add wave -noupdate /prbs_pam_4_tb/pam4_verification
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {716957 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 430
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
WaveRestoreZoom {224400 ps} {1845416 ps}
