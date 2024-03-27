# TCL File Generated by Component Editor 22.1
# Mon Oct 16 22:03:20 EDT 2023
# DO NOT MODIFY


# 
# prbs "prbs" v1.0
#  2023.10.16.22:03:20
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module prbs
# 
set_module_property DESCRIPTION ""
set_module_property NAME prbs
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME prbs
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL prbs31
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file prbs.v VERILOG PATH ../rtl/Tx_sim/prbs.v TOP_LEVEL_FILE


# 
# parameters
# 
add_parameter SEED STD_LOGIC_VECTOR 1756177695
set_parameter_property SEED DEFAULT_VALUE 1756177695
set_parameter_property SEED DISPLAY_NAME SEED
set_parameter_property SEED WIDTH 33
set_parameter_property SEED TYPE STD_LOGIC_VECTOR
set_parameter_property SEED UNITS None
set_parameter_property SEED ALLOWED_RANGES 0:8589934591
set_parameter_property SEED HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point rstn
# 
add_interface rstn reset end
set_interface_property rstn associatedClock clock
set_interface_property rstn synchronousEdges DEASSERT
set_interface_property rstn ENABLED true
set_interface_property rstn EXPORT_OF ""
set_interface_property rstn PORT_NAME_MAP ""
set_interface_property rstn CMSIS_SVD_VARIABLES ""
set_interface_property rstn SVD_ADDRESS_GROUP ""

add_interface_port rstn rstn reset_n Input 1


# 
# connection point data_out
# 
add_interface data_out conduit end
set_interface_property data_out associatedClock clock
set_interface_property data_out associatedReset rstn
set_interface_property data_out ENABLED true
set_interface_property data_out EXPORT_OF ""
set_interface_property data_out PORT_NAME_MAP ""
set_interface_property data_out CMSIS_SVD_VARIABLES ""
set_interface_property data_out SVD_ADDRESS_GROUP ""

add_interface_port data_out data_out data_out Output 1
add_interface_port data_out data_out_valid data_out_valid Output 1


# 
# connection point prbs_ctrl
# 
add_interface prbs_ctrl conduit end
set_interface_property prbs_ctrl associatedClock clock
set_interface_property prbs_ctrl associatedReset rstn
set_interface_property prbs_ctrl ENABLED true
set_interface_property prbs_ctrl EXPORT_OF ""
set_interface_property prbs_ctrl PORT_NAME_MAP ""
set_interface_property prbs_ctrl CMSIS_SVD_VARIABLES ""
set_interface_property prbs_ctrl SVD_ADDRESS_GROUP ""

add_interface_port prbs_ctrl en en Input 1
