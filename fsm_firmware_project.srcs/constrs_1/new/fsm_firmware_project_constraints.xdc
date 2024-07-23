# Core Period Constraint. This constraint can be modified, and is
# valid as long as it is met after place and route.
set_property -dict { PACKAGE_PIN G10  IOSTANDARD LVDS} [get_ports clk_in_p]
set_property -dict { PACKAGE_PIN F10  IOSTANDARD LVDS} [get_ports clk_in_n]