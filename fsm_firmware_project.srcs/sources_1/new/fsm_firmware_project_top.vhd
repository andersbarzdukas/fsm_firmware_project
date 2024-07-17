----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2024 09:26:27 PM
-- Design Name: 
-- Module Name: fsm_firmware_project_top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity fsm_firmware_project_top is
    Port ( clk : in STD_LOGIC);
end fsm_firmware_project_top;


--The goal of this project is to make a finite state machine that writes and reads data from the BRAM
--The rough steps for completing this goal are:
--1. Create and buffer all clocks (done for you)
--2. Declare and instantiate the BRAM module in this firmware
--3. Create a counter that counts from 0 to the depth of the BRAM
--4. Create a process controlling a FSM and use the counter and the signals below to control reading and writing to the BRAM
--NOTE: See below for a predefined FSM type you can use
--4.b. (optional but recommended) Create a separate counter that controls state transitions in the FSM
--5. Run the simulation and examine the behavior noticed by the firmware
--5.b. Debug any issues and iteratively improve the firmware
--6. (optional but recommended) Try and generate the bistream
--7. (extra) Create an ILA to look at the various signals

--We will talk about the first part of this project maybe Friday, but definitely on Tuesday
--Please try to finish with at least step 5 by that point. Reaching step 6 would be preferred.
--For help please see the following resources,
--BRAM: https://docs.amd.com/v/u/en-US/ug573-ultrascale-memory-resources
--FSM:  https://vhdlwhiz.com/n-process-state-machine/
--KCU105: https://www.xilinx.com/content/dam/xilinx/support/documents/boards_and_kits/kcu105/ug917-kcu105-eval-bd.pdf


architecture Behavioral of fsm_firmware_project_top is

SIGNAL clk_buf : STD_LOGIC := 'U';
SIGNAL RSTA: STD_LOGIC := '0';
SIGNAL ENA: STD_LOGIC := '0';
SIGNAL WEA: STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
SIGNAL ADDRA: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL DINA: STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
SIGNAL DOUTA: STD_LOGIC_VECTOR(15 DOWNTO 0);

--Declaration of FSM type. In VHDL you can define your own type and the values they may take
--For information about this please see: https://fpgatutorial.com/vhdl-records-arrays-and-custom-types/
TYPE FSM_STATES IS (IDLE_STATE, READ_STATE, WRITE_STATE);
SIGNAL FSM_STATE : FSM_STATES := IDLE_STATE;


--This is the ipcore used for the BRAM
COMPONENT blk_mem_gen_0 
  PORT (
      --Inputs - Port A
    ENA            : IN STD_LOGIC;  --opt port
    WEA            : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    ADDRA          : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    DINA           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DOUTA          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    CLKA       : IN STD_LOGIC
  );
END COMPONENT;


begin

--Added a buffered clock signal
u_bufg: bufg PORT map(i => CLK, o => CLK_BUF);
 
--Instatiation of the blk_mem_generator
--Replace the constant values with the correct signals 
u_clk_mem_gen_0 : blk_mem_gen_0
port map(
  ENA => '1',
  WEA => (others => '0'),
  ADDRA => (others => '0'),
  DINA => (others => '0'),
  --DOUTA => ,
  CLKA => '1'
);
 
 
--Want a process that counts from 0 to the depth of the BRAM
--Also connect the counter value to signals that will be incremented
counter_address : process(clk) 
--This variable is purposely at the wrong length. Think about if you want to use an integer or how long your vector should be!
variable counter : std_logic_vector(0 downto 0) := (others => '0');
begin 
  --Within this if statement add the logic for the counter
  if(rising_edge(clk_buf)) then 


  end if;
end process;

--Define the logic of the FSM machine in the process(es) below.
--Please refer back to the FSM reference on line 54
fsm_logic : process(clk_buf)
begin
  if rising_edge(clk_buf) then
  
  end if;
end process; 


--At this point stop and try the simulation! Are you seeing the correct behavior? If not what signals are wrong and where are they set? 
--Is this a logic issue or a potential timing issue.





end Behavioral;
