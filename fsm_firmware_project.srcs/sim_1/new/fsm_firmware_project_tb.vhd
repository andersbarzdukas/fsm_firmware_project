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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--This is an extremely basic top file that creates a clock and sends it to the fsm_firmware_project_top file.
entity fsm_firmware_project_tb is
end fsm_firmware_project_tb;

architecture Behavioral of fsm_firmware_project_tb is

--Defining a clk signal and giving it an initial value
signal clk : std_logic := '0';

--Declaring top file as a component
component fsm_firmware_project_top
port(clk : std_logic);
end component;

begin

--Creates a clock that alternates every 20 ns
clk <= not clk after 20 ns;

--Instatiates the top file in this simulation file
u_fsm_firmware_project_top : fsm_firmware_project_top port map(clk => clk);




end Behavioral;
