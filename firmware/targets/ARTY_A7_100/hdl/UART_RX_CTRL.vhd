----------------------------------------------------------------------------
--	UART_RX_CTRL.vhd -- UART Data Transfer Component
----------------------------------------------------------------------------
-- Author:  Andrew Whitbeck
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
--	This component may be used to transfer data over a UART device. It will
-- read serialized data and deserialize it into an 8-bit word. The serialized
-- data has the following characteristics:
--         *9600 Baud Rate
--         *8 data bits, LSB first
--         *1 stop bit
--         *no parity
--         				
-- Port Descriptions:
--
--    DATA - The parallel data to be sent. Must be valid the clock cycle
--           that SEND has gone high.
--    CLK  - A 100 MHz clock is expected
--   READY - This signal goes low once a send operation has begun and
--           remains low until it has completed and the module is ready to
--           send another byte.
-- UART_RX - This signal should be routed to the appropriate TX pin of the 
--           external UART device.
--   
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
-- Revision History:
--  01/06/2023: Created using Vivado 2023.2
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity UART_RX_CTRL is
    Port ( DATA : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           DATA_READY : out  STD_LOGIC;
           UART_RX : in  STD_LOGIC);
end UART_RX_CTRL;

architecture Behavioral of UART_RX_CTRL is

type RX_STATE_TYPE is (READY, READ_BIT, START_READ, END_READ, ERROR);
-- READY : data is ready to be consumed by user.  Should go high when 
--         stop bit is detected.  Should go low when start bit has been detected.
--         Transitions to START_READ.
-- START_READ: state directly after start bit has been found.  Transitions
--             to READ_BIT.
-- END_READ: stop bit has been detected.  Transitions to READY
-- READ_BIT: registers data from UART_RX.  Once stop bit has been found, transition
--           to READY.  If stop bit is not found on the 9th registration, transition
--           to ERROR state
-- ERROR:    signifies that stop bit was not found.  Transitions to READY after 
--           100,000 clock cycles.  
 
constant BIT_TMR_MAX : std_logic_vector(13 downto 0) := "10100010110000"; --10416 = (round(100MHz / 9600)) - 1
constant BIT_INDEX_MAX : natural := 8;
constant BIT_ERR_TMR_MAX : std_logic_vector(16 downto 0) := "11000011010100000"; -- 100,000

--Counter that keeps track of the number of clock cycles since last error.  
signal errorTimer : std_logic_vector(16 downto 0) := (others => '0');

--Contains the index of the next bit in txData that needs to be transferred 
signal bitIndex : natural;

--Register for storing previous clock cycle data
signal oldData : std_logic := '1';

signal rxState : RX_STATE_TYPE := READY;

begin



buffer_data : process (CLK)
begin
    if (rising_edge(CLK)) then
        oldData <= UART_RX;
    end if;
end process;

--Next state logic
next_rxState_process : process (CLK)
begin
	if (rising_edge(CLK)) then
		case rxState is 
		when READY =>
			if (oldData = '1') AND (UART_RX = '0') then
				rxState <= READ_BIT;
				bitIndex <= 0;
                rxState <= READ_BIT;
				DATA_READY <= '0';
			end if;
		when READ_BIT =>
			if (bitIndex = BIT_INDEX_MAX) then
			    if ( UART_RX = '1' ) then 
				    rxState <= READY;
				    DATA_READY <= '1';
				else 
				    errorTimer <= (others=>'0');
				    rxState <= ERROR;
					DATA_READY <= '0';
				end if;
		    else
       		    DATA(bitIndex) <= UART_RX;
   			    bitIndex <= bitIndex + 1;	
			end if;			
		when ERROR => 
		    -- BIT_ERR_TMR_MAX
		    if  errorTimer = BIT_ERR_TMR_MAX then
		      errorTimer <= (others=>'0');
		      rxState <= READY;
		    else 
		      errorTimer <= errorTimer + 1; 
		    end if;
		when others=> --should never be reached
			rxState <= READY;
		end case;
	end if;
end process;

end Behavioral;

