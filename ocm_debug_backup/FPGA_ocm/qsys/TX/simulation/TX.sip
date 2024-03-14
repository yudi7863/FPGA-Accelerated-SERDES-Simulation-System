set_global_assignment -entity "TX" -library "lib_TX" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "TX" -library "lib_TX" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "TX" -library "lib_TX" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_TX" -name SPD_FILE [file join $::quartus(sip_path) "../TX.spd"]
set_global_assignment -library "lib_TX" -name MISC_FILE [file join $::quartus(sip_path) "../../TX.qsys"]

set_global_assignment -library "lib_TX" -name MISC_FILE [file join $::quartus(sip_path) "TX.v"]
