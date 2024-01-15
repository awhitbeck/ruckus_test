#load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

loadSource -path "$::DIR_PATH/hdl/GPIO_Demo.vhd"
loadSource -path "$::DIR_PATH/hdl/debouncer.vhd"
loadSource -path "$::DIR_PATH/hdl/RGB_controller.vhd"
loadSource -path "$::DIR_PATH/hdl/UART_RX_CTRL.vhd"
loadSource -path "$::DIR_PATH/hdl/UART_TX_CTRL.vhd"
loadConstraints -path "$::DIR_PATH/constraints/Arty_Master.xdc"
