----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2024 10:44:19 PM
-- Design Name: 
-- Module Name: fsm_firmware_project_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library mylib;
use mylib.utilities.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity fsm_firmware_project_tb is
end fsm_firmware_project_tb;

architecture Behavioral of fsm_firmware_project_tb is

--Defining a clk signal and giving it an initial value
signal clk : std_logic := '0';
signal nclk : std_logic := '0';
signal reset : std_logic := '0';
signal start : std_logic := '0';
signal STATE_MACH : FSM_STATES;

--Declaring top file as a component
component fsm_firmware_project_top
port(clk_p : std_logic; clk_n : std_logic; reset_signal : std_logic; start_signal : std_logic; fsmstate : out FSM_STATES);
end component;

begin
Clock_gen : process
begin
--Creates a clock that alternates every 100 ns
    clk <= '0';
    wait for 100 ns;
    clk <= '1';
    wait for 100 ns;
end process;

--clk <= not clk after 100 ns;
nclk <= not clk;

--Choose a time to set the reset_signal
reset_gen : process
begin 
    reset <= '0';
    wait for 15 us;
    reset <= '1';
    wait for 200 ns;
    reset <= '0';
    wait;
end process;

fsm_gen : process (clk, STATE_MACH)
begin
if (rising_edge(clk))then
    if (STATE_MACH = IDLE_STATE)then    
      start <= '1';
    else 
      start <= '0';
    end if;
end if;
end process;

--fsm_gen : process 
--begin
--    start <= '0';
--    wait for 5 us;
--    start <= '1';
--    wait for 400 ns;
--    start <= '0';
--    wait; --until STATE_MACH = IDLE_STATE;
--end process;

--Instatiates the top file in this simulation file
u_fsm_firmware_project_top : fsm_firmware_project_top port map(clk_p => clk, clk_n => nclk, reset_signal => reset, start_signal => start, fsmstate => STATE_MACH);

end Behavioral;
