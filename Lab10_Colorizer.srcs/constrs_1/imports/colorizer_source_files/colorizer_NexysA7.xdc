## Constraint file for ELEC 3500 Vivado Lab: Colorizer System
## Board: Nexys A7-100T

# Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports i_sys_clk]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz

# Reset signal
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {i_sys_rst}]

# UART signals
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports i_uart_rx_in]; #IO_L7P_T1_AD6P_35 Sch=uart_txd_in
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports o_uart_tx_out]; #IO_L11N_T1_SRCC_35 Sch=uart_rxd_out