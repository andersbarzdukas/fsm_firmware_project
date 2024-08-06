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

entity fsm_firmware_project_top is
    Port ( clk_in_p : in STD_LOGIC;
           clk_in_n : in STD_LOGIC );
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
SIGNAL clk_10MHz : STD_LOGIC := 'U';
SIGNAL clk_40MHz : STD_LOGIC := 'U';
SIGNAL RSTA: STD_LOGIC := '0';
SIGNAL ENA: STD_LOGIC := '0';
SIGNAL WEA: STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
SIGNAL ADDRA: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL DINA: STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
SIGNAL DOUTA: STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL NOT_COUNTING: STD_LOGIC := '1';
SIGNAL RESET_SIGNAL: STD_LOGIC := '1';
SIGNAL COUNTER_RESET: STD_LOGIC := '0';
SIGNAL COUNTER_SIGNAL: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL MAX_ADDR_REACHED: STD_LOGIC := '0';

SIGNAL ILA_PROBE_2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
SIGNAL VIO_RESET : STD_LOGIC := 'U';

--Declaration of FSM type. In VHDL you can define your own type and the values they may take
--For information about this please see: https://fpgatutorial.com/vhdl-records-arrays-and-custom-types/
TYPE FSM_STATES IS (IDLE_STATE, READ_STATE, WRITE_STATE);
SIGNAL FSM_STATE : FSM_STATES := IDLE_STATE;
SIGNAL NEXT_STATE : FSM_STATES := IDLE_STATE;

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

COMPONENT ila_0
  PORT(
    CLK : IN STD_LOGIC;
    PROBE0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    PROBE1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    PROBE2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT vio_0
  PORT(
    CLK : IN STD_LOGIC;
    PROBE_OUT0 : OUT STD_LOGIC
  );
END COMPONENT;


COMPONENT clk_wiz_0
  PORT(
    CLK_IN1 : IN STD_LOGIC;
    RESET : IN STD_LOGIC;
    CLK_OUT1 : OUT STD_LOGIC;
    CLK_OUT2 : OUT STD_LOGIC
  );
END COMPONENT;


begin

--Added a buffered clock signal
IBUFGDS_u : IBUFDS port map (I => clk_in_p,IB => clk_in_n,O => clk_unbuf);
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

--Defines the ILA and the signals that we want to track
u_ila_0 : ila_0
port map(
  clk => clk_40MHz,
  probe0 => dina,
  probe1 => douta,
  probe2 => ila_probe_2
);

--Defines the VIO and declares a reset signal
u_vio_0 : vio_0
port map(
  clk => clk_buf,
  probe_out0 => vio_reset
);

u_clk_wiz_0 : clk_wiz_0
port map(
  clk_in1 => clk_unbuf,
  reset => '0',
  clk_out1 => clk_10MHz,
  clk_out2 => clk_40MHz
);

--We want to track a lot of different signals which can be bundled into one std_logic_vector.
--Later we can use a .tcl script to unpack these.
ila_probe_2(3 downto 0) <= ADDRA;
ila_probe_2(4 downto 4) <= wea;
ila_probe_2(5) <= ena;
ila_probe_2(6 downto 5) <= "00" when FSM_STATE=IDLE_STATE else 
                           "01" when FSM_STATE=WRITE_STATE else
                           "10" when FSM_STATE=READ_STATE else
                           "11";
ila_probe_2(7) <= reset_signal;
ila_probe_2(8) <= vio_reset;                          
 
--Want a process that counts from 0 to the depth of the BRAM
--Also connect the counter value to signals that will be incremented
counter_address : process(clk_buf,clk_10Mhz) 
--This variable is purposely at the wrong length. Think about if you want to use an integer or how long your vector should be!
variable counter : std_logic_vector(4 downto 0) := (others => '0');
begin 
  --Within this if statement add the logic for the counter
  if(rising_edge(clk_10MHz)) then 
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

--Define the logic of the FSM machine in the process(es) below.
--Please refer back to the FSM reference on line 54
fsm_state_change : process(clk_10MHz)
begin
  if rising_edge(clk_10MHz) then
    fsm_state <= next_state;
  end if;
end process; 

fsm_logic : process(fsm_state,reset_signal,vio_reset,max_addr_reached,counter_reset,wea,ena,not_counting)
begin
  --if rising_edge(clk_10MHz) then
    --combined_reset <= reset_signal or vio_reset;
    next_state <= fsm_state;
  
    case fsm_state is
    when IDLE_STATE => 
        --if(combined_reset) then
        if(reset_signal = '1' or vio_reset='1') then
            next_state <= WRITE_STATE;
        else 
            next_state <= IDLE_STATE;
        end if;
    when READ_STATE =>
        reset_signal <= '0';
        
        if(not_counting='1' and max_addr_reached='0') then 
            not_counting  <= '0';
            counter_reset <= '1';
            
        elsif(max_addr_reached='0') then
            counter_reset <= '0';
            wea <= "0";
            ena <= '1';
            
        else 
            wea <= "0";
            ena <= '0';
            not_counting <= '1';
            counter_reset <= '1';
            next_state <= WRITE_STATE;
        end if;
        
        dina <= (others => '0');
        addra <= counter_signal;
        
    when WRITE_STATE =>
        
        if(not_counting='1' and max_addr_reached='0') then 
            not_counting  <= '0';
            counter_reset <= '1';
            
        elsif(max_addr_reached='0') then
            counter_reset <= '0';
            wea <= "1";
            ena <= '1';
            
        else 
            wea <= "0";
            ena <= '0';
            not_counting <= '1';
            counter_reset <= '1';
            next_state <= READ_STATE;
            
        end if;
    
        dina(3 downto 0) <= counter_signal;
        addra <= counter_signal;
    
    when OTHERS =>
        next_state <= idle_state;
 
    end case;
    
    if(vio_reset='1') then 
      next_state <= idle_state;
    end if;
  --end if;
end process; 

--At this point stop and try the simulation! Are you seeing the correct behavior? If not what signals are wrong and where are they set? 
--Is this a logic issue or a potential timing issue.





end Behavioral;
