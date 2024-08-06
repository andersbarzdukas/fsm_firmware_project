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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
library mylib;
USE mylib.utilities.all;

entity fsm_firmware_project_top is
    Port ( clk_p : in STD_LOGIC;
           clk_n : in STD_LOGIC;
           reset_signal : in STD_LOGIC;
           start_signal : in STD_LOGIC;
           fsmstate : out FSM_STATES );
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
SIGNAL clk_unbuf : STD_LOGIC := 'U';
SIGNAL RSTA: STD_LOGIC := '0';
SIGNAL ENA: STD_LOGIC := '0';
SIGNAL WEA: STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
SIGNAL ADDRA: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL DINA: STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
SIGNAL DOUTA: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL NOT_COUNTING: STD_LOGIC := '1';

--SIGNAL RESET_SIGNAL: STD_LOGIC := '0';
SIGNAL COUNTER_RESET: STD_LOGIC := '0';
SIGNAL COUNTER_SIGNAL: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL MAX_ADDR_REACHED: STD_LOGIC := '0';
SIGNAL FSM_STATE : FSM_STATES := IDLE_STATE;
SIGNAL NEXT_STATE : FSM_STATES := IDLE_STATE;
-------------------------------------------------------------------------------------------------------------------------
--Signals I added
-------------------------------------------------------------------------------------------------------------------------
SIGNAL wait_1: STD_LOGIC := '0'; 
SIGNAL wait_2: STD_LOGIC := '0';
SIGNAL wait_3: STD_LOGIC := '0';
SIGNAL wait_4: STD_LOGIC := '0';
SIGNAL wait_5: STD_LOGIC := '0';
SIGNAL hold_en_1: STD_LOGIC := '0';
SIGNAL hold_en_2: STD_LOGIC := '0';
SIGNAL data_out: STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
SIGNAL dav_1: STD_LOGIC := '0';
SIGNAL dav_2: STD_LOGIC := '0';
SIGNAL dav_3: STD_LOGIC := '0';
SIGNAL dav_4: STD_LOGIC := '0';
-------------------------------------------------------------------------------------------------------------------------

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
IBUFGDS_u : IBUFDS port map (I => clk_p,IB => clk_n,O => clk_unbuf);
u_bufg: bufg PORT map(i => clk_unbuf, o => clk_buf);
 
--Instatiation of the blk_mem_generator
--Replace the constant values with the correct signals 
u_clk_mem_gen_0 : blk_mem_gen_0
port map(
  ENA => ENA,
  WEA => WEA,
  ADDRA => ADDRA,
  DINA => DINA,
  DOUTA => DOUTA,
  CLKA => CLK_BUF
);
 
--Want a process that counts from 0 to the depth of the BRAM
--Also connect the counter value to signals that will be incremented
counter_address : process(clk_buf) 
--This variable is purposely at the wrong length. Think about if you want to use an integer or how long your vector should be!
variable counter : std_logic_vector(4 downto 0) := (others => '0');
begin 
  --Within this if statement add the logic for the counter
  if(rising_edge(clk_buf)) then 
    if(counter_reset='1') then 
        counter := (others => '0');
    elsif(not_counting='1') then
        counter := counter;
    else 
        counter := counter + '1';
    end if;
    
    counter_signal <= counter(3 downto 0);
    max_addr_reached <= counter(4);
  end if;
end process;

-------------------------------------------------------------------------------------------------------------------------
-- My State Machine and added logic
-------------------------------------------------------------------------------------------------------------------------
fsmstate <= fsm_state;

set_wait : process (clk_buf, fsm_state, wait_5)
begin
if(rising_edge(clk_buf)) then
    if((fsm_state = WAIT_STATE) and wait_5 = '0') then
		wait_1 <= '1';
		wait_2 <= wait_1;
		wait_3 <= wait_2;
		wait_4 <= wait_3;
		wait_5 <= wait_4;
    else
	   wait_1 <= '0';
	   wait_2 <= '0';
	   wait_3 <= '0';
	   wait_4 <= '0';
	   wait_5 <= '0';
    end if;
end if;
end process;

set_en : process (clk_buf, max_addr_reached)
begin
if(rising_edge(clk_buf)) then
    if((max_addr_reached = '1')) then
		hold_en_1 <= '1';
		hold_en_2 <= hold_en_1;
    else
		hold_en_1 <= '0';
		hold_en_2 <= '0';
    end if;
end if;
end process;

dav_logic : process (clk_buf, reset_signal, max_addr_reached, counter_reset, fsm_state)
begin
if(rising_edge(clk_buf)) then
    if (reset_signal ='1') then
		dav_1 <= '0';
		dav_2 <= '0';
		dav_3 <= '0';
		dav_4 <= '0';
    elsif (counter_reset = '1') then
		dav_1 <= '1';
		dav_2 <= dav_1;
		dav_3 <= dav_2;
		dav_4 <= dav_3;
    elsif ((fsm_state = READ_STATE) and max_addr_reached ='0') then
		dav_1 <= dav_1;
		dav_2 <= dav_1;
		dav_3 <= dav_2;
		dav_4 <= dav_3;
    else 
		dav_1 <= '0';
		dav_2 <= '0';
		dav_3 <= dav_2;
		dav_4 <= dav_3;
    end if;
end if;
end process;

send_data : process (clk_buf, dav_4)
begin
if(rising_edge(clk_buf)) then
    data_out <= DOUTA;
end if;
end process;

fsm_state_change : process(clk_buf)
begin
  if rising_edge(clk_buf) then
    fsm_state <= next_state;
  end if;
end process; 

fsm_logic : process(fsm_state,reset_signal,start_signal,next_state,counter_signal,not_counting,counter_reset, max_addr_reached, wait_5, hold_en_1, hold_en_2)
begin
    case fsm_state is
    when IDLE_STATE => 
         not_counting  <= not_counting;
         counter_reset <= '1';
         wea <= "0";
         ena <= '0';
         dina <= (others => '0');
         addra <= counter_signal;
         if (reset_signal = '1') then
            next_state <= IDLE_STATE;
         elsif(start_signal = '1') then
            next_state <= WAIT_STATE;
         else 
            next_state <= next_state;
         end if;
		
	when WAIT_STATE =>
         not_counting  <= '1';
         counter_reset <= '0';
         dina <= dina;
         addra <= counter_signal;
         if (reset_signal = '1') then
            wea <= "0";
            ena <= '0';
            next_state <= IDLE_STATE;
		 elsif (wait_5 = '1') then
            wea <= "0";
            ena <= '0';
            next_state <= WRITE_STATE;
        else
            wea <= "0";
            ena <= '0';
            next_state <= next_state;
		end if;
		
    when READ_STATE =>
		dina <= (others => '0');
        addra <= (counter_signal);
        if (reset_signal = '1') then
            wea <= "0";
            ena <= '0';
            next_state <= IDLE_STATE;
            counter_reset <= counter_reset;
        elsif (not_counting='1' and max_addr_reached='0') then 
            next_state <= next_state;
            not_counting  <= '0';
            counter_reset <= '0';
            wea <= wea;
            ena <= ena;
        elsif (max_addr_reached='0') then
            next_state <= next_state;
            not_counting  <= not_counting;
            counter_reset <= '0';
            wea <= "0";
            ena <= '1';
        elsif (max_addr_reached = '1' and (hold_en_1 = '0')) then
            wea <= "0";
            ena <= ena;
            next_state <= next_state;
            not_counting <= '1';
            counter_reset <= '0';
        elsif (max_addr_reached = '1' and (hold_en_2 = '1')) then
            wea <= "0";
            ena <= '0';
            not_counting <= '1';
            counter_reset <= '1';
            next_state <= WAIT_STATE;
        end if;
        
    when WRITE_STATE =>
        dina <= (counter_signal & x"fab");
        addra <= counter_signal;
        if (reset_signal = '1') then
            wea <= "0";
            ena <= '0';
            next_state <= IDLE_STATE;
            counter_reset  <= counter_reset;
            not_counting  <= not_counting;
        elsif (not_counting='1' and max_addr_reached='0') then 
            next_state <= next_state;
            not_counting  <= '0';
            counter_reset <= '0';
            wea <= wea;
            ena <= ena;
        elsif (max_addr_reached = '0') then
            next_state <= next_state;
            not_counting  <= not_counting;
            counter_reset <= '0';
            wea <= "1";
            ena <= '1';
        elsif (max_addr_reached = '1' and (hold_en_1 = '0')) then
            wea <= "0";
            ena <= ena;
            next_state <= next_state;
            not_counting <= '1';
            counter_reset <= '0';
        elsif (max_addr_reached = '1' and (hold_en_2 = '1')) then
            wea <= "0";
            ena <= '0';
            next_state <= READ_STATE;
            not_counting <= '1';
            counter_reset <= '1';
        end if;
        
    when OTHERS =>
         not_counting  <= not_counting;
         counter_reset <= counter_reset;
         wea <= wea;
         ena <= ena;
         dina <= dina;
         addra <= addra;
         next_state <= next_state;
 
    end case;
end process; 

--Define the logic of the FSM machine in the process(es) below.
--Please refer back to the FSM reference on line 54
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--  State Machine Before Adding the Waiting State:

--fsm_state_change : process(clk_buf)
--begin
--  if rising_edge(clk_buf) then
--    fsm_state <= next_state;
--  end if;
--end process; 

--fsm_logic : process(fsm_state,reset_signal,start_signal,next_state,counter_signal,not_counting,max_addr_reached)
--begin
--    case fsm_state is
--    when IDLE_STATE => 
--         not_counting  <= not_counting;
--         counter_reset <= counter_reset;
--         wea <= wea;
--         ena <= ena;
----         reset_signal <= reset_signal;
--         dina <= dina;
--         addra <= addra;
--        if(start_signal = '1') then
--            next_state <= WRITE_STATE;
--        else 
--            next_state <= IDLE_STATE;
--        end if;
        
--    when READ_STATE =>
--        dina <= (others => '0');
--        addra <= counter_signal;
----         reset_signal <= '0';
--        if(not_counting='1' and max_addr_reached='0') then 
--            next_state <= next_state;
--            not_counting  <= '0';
--            counter_reset <= '1';
--            wea <= wea;
--            ena <= ena;
--        elsif(max_addr_reached='0') then
--            next_state <= next_state;
--            not_counting  <= not_counting;
--            counter_reset <= '0';
--            wea <= "0";
--            ena <= '1';
--        else 
--            wea <= "0";
--            ena <= '0';
--            not_counting <= '1';
--            counter_reset <= '1';
--            next_state <= IDLE_STATE;
--        end if;
            
--    when WRITE_STATE =>
--        dina(3 downto 0) <= counter_signal;
--        addra <= counter_signal;
----         reset_signal <= reset_signal;
--        if(not_counting='1' and max_addr_reached='0') then 
--            next_state <= next_state;
--            not_counting  <= '0';
--            counter_reset <= '1';
--            wea <= wea;
--            ena <= ena;
--        elsif(max_addr_reached='0') then
--            next_state <= next_state;
--            not_counting  <= not_counting;
--            counter_reset <= '0';
--            wea <= "1";
--            ena <= '1';
--        else 
--            wea <= "0";
--            ena <= '0';
--            next_state <= READ_STATE;
--            not_counting <= '1';
--            counter_reset <= '1';
            
--        end if;
        
--    when OTHERS =>
--         not_counting  <= not_counting;
--         counter_reset <= counter_reset;
--         wea <= wea;
--         ena <= ena;
----         reset_signal <= reset_signal;
--         dina <= dina;
--         addra <= addra;
--         next_state <= next_state;
 
--    end case;
--end process; 


--At this point stop and try the simulation! Are you seeing the correct behavior? If not what signals are wrong and where are they set? 
--Is this a logic issue or a potential timing issue.


end Behavioral;
