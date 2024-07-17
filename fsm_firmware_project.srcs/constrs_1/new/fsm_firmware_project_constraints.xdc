# Core Period Constraint. This constraint can be modified, and is
# valid as long as it is met after place and route.
create_clock -name "TS_CLKA" -period 20.0 [ get_ports CLK ]
#The above line generates a clock with period of 20 ns