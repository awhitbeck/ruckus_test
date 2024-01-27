----------------------------------------------------------------------------
--	GPIO_Demo.vhd -- Nexys4DDR GPIO/UART Demonstration Project
----------------------------------------------------------------------------
-- Author:  Marshall Wingerson Adapted from Sam Bobrowicz
--          Copyright 2013 Digilent, Inc.
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
--	The GPIO/UART Demo project demonstrates a simple usage of the Nexys4DDR's 
--  GPIO and UART. The behavior is as follows:
--
--	      *The 16 User LEDs are tied to the 16 User Switches. While the center
--			 User button is pressed, the LEDs are instead tied to GND
--	      *The 7-Segment display counts from 0 to 9 on each of its 8
--        digits. This count is reset when the center button is pressed.
--        Also, single anodes of the 7-Segment display are blanked by
--	       holding BTNU, BTNL, BTND, or BTNR. Holding the center button 
--        blanks all the 7-Segment anodes.
--       *An introduction message is sent across the UART when the device
--        is finished being configured, and after the center User button
--        is pressed.
--       *A message is sent over UART whenever BTNU, BTNL, BTND, or BTNR is
--        pressed.
--       *The Tri-Color LEDs cycle through several colors in a ~4 second loop
--       *Data from the microphone is collected and transmitted over the mono
--        audio out port.
--       *Note that the center user button behaves as a user reset button
--        and is referred to as such in the code comments below
--        
--	All UART communication can be captured by attaching the UART port to a
-- computer running a Terminal program with 9600 Baud Rate, 8 data bits, no 
-- parity, and 1 stop bit.																
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
-- Revision History:
--  08/08/2011(SamB): Created using Xilinx Tools 13.2
--  08/27/2013(MarshallW): Modified for the Nexys4 with Xilinx ISE 14.4\
--  		--added RGB and microphone
--  12/10/2014(SamB): Ported to Nexys4DDR and updated to Vivado 2014.4
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--The IEEE.std_logic_unsigned contains definitions that allow 
--std_logic_vector types to be used with the + operator to instantiate a 
--counter.
use IEEE.std_logic_unsigned.all;

library surf;
use surf.StdRtlPkg.all;

entity GPIO_demo is
    Generic(
      TPD_G             : time                  := 1 ns;
      CLK_FREQ_G        : real                  := 100.0e6;
      BAUD_RATE_G       : integer               := 9600;
      BAUD_MULT_G       : integer range 1 to 16 := 16;
      STOP_BITS_G       : integer range 1 to 2  := 1;
      PARITY_G          : string                := "NONE";  -- "NONE" "ODD" "EVEN"
      DATA_WIDTH_G      : integer range 5 to 8  := 8);


    Port ( CLK 			: in  STD_LOGIC := '0';
           LED 			: out  STD_LOGIC_VECTOR (3 downto 0) := (others=>'0');
           ja1          : out STD_LOGIC := '0';
           ja2          : out STD_LOGIC := '0';
           ja3          : out STD_LOGIC := '0';
           ja4          : out STD_LOGIC := '0';
           ja7          : out STD_LOGIC := '0';
           ja8          : out STD_LOGIC := '0';
           ja9          : out STD_LOGIC := '0';
           UART_RXD 	: in  STD_LOGIC := '1'
			  );
end GPIO_demo;

architecture Behavioral of GPIO_demo is


type RESET_STATE_TYPE is (RUNNING, HOLD);

--constant TMR_VAL_MAX : std_logic_vector(3 downto 0) := "1001"; --9

--constant RESET_CNTR_MAX : std_logic_vector(17 downto 0) := "110000110101000000";-- 100,000,000 * 0.002 = 200,000 = clk cycles per 2 ms

--constant MAX_STR_LEN : integer := 31;

--constant WELCOME_STR_LEN : natural := 31;
--constant BTN_STR_LEN : natural := 24;

signal clk_cntr_reg : std_logic_vector (4 downto 0) := (others=>'0'); 

--this counter counts the amount of time paused in the UART reset state
signal reset_cntr : std_logic_vector (17 downto 0) := (others=>'0');

--signal for storing data received on UART
signal uart_in : std_logic_vector(7 downto 0) := (others=>'0');
signal uart_in_ready : std_logic := '0' ;
signal uart_in_valid : std_logic := '0' ;
signal uartRX : std_logic;
signal UART_CLK : std_logic := '0';
constant BIT_TMR_MAX : std_logic_vector(13 downto 0) := "10100010110000"; --10416 = (round(100MHz / 9600)) - 1
--Counter that keeps track of the number of clock cycles the current bit has been held stable over the
--UART RX line. It is used to signal when the ne
signal bitTmr : std_logic_vector(13 downto 0) := (others => '0');
signal reset : std_logic := '0';
signal UART_CLK_DIV16 : std_logic := '0';
begin

----------------------------------------------------------
------                LED Control                  -------
----------------------------------------------------------

LED_control : process (CLK)
begin
    if (rising_edge(CLK)) then
        if uart_in_valid = '1' then
            if uart_in = x"1F" then
                LED <= "0001";
            elsif uart_in = x"2F" then
                LED <= "0010";
            elsif uart_in = x"3F" then
                LED <= "0100";
            elsif uart_in = x"4F" then
                LED <= "1000";
            else 
                LED <= "0000";
            end if;
        end if;
    end if; 
			 			 
end process;
				  
--Reset
reset_controller : process(UART_CLK)
  variable counter : natural :=0;
  variable reset_state : RESET_STATE_TYPE := RUNNING;
begin
  if( rising_edge(UART_CLK) ) then
    case reset_state is
      when RUNNING =>
        if(counter = 10000) then
          counter := 0;
          reset_state := HOLD;
          reset <= '1';
        else
          counter := counter+1;
        end if;
      when HOLD =>
        if(counter = 100) then
          counter := 0;
          reset_state := RUNNING;
          reset <= '0';
        else
          counter := counter+1;
        end if;
    end case;
  end if;
end process;

--Stream uart_in_ready and uart_in to PMOD pins for debugging
--When UART receiver rdValid goes high, this process is triggered
--It streams data to pin and sets rdReady high for one clock cycle
debug_uart : process(UART_CLK)
variable counter : natural := 0;
begin

    if(rising_edge(UART_CLK)) then
        if uart_in_valid = '1' and uart_in_ready = '0' then 
            counter := counter+1;
            if counter < 8 then
               ja4 <= uart_in(counter);
            elsif counter < 16 then
               ja4 <= '0';
            elsif counter >= 16 then 
               ja4 <= '0';
               counter := 0;
               uart_in_ready <= '1';
            end if;
        end if;
        if uart_in_ready = '1' then
            uart_in_ready <= '0';
        end if;
    end if;
end process;            

--deassert_ready : process(UART_CLK)
--variable counter : natural := 0;
--begin
--    if rising_edge(UART_CLK) then
--        if uart_in_ready = '1' then 
--            counter := counter+1;
--            if counter > 15 then 
--                uart_in_ready <= '0';
--                counter := 0;
--            end if;
--        end if;
--    end if;
--end process;        


--divide uart clock by 16
proc_uart_clk_div16 : process( UART_CLK )
variable counter : natural := 0;
begin
    if rising_edge( UART_CLK ) then 
        counter := counter+1;
        if counter >15 then 
            counter := 0;
            UART_CLK_DIV16 <= not UART_CLK_DIV16;
        end if;
    end if;
end process;


   -------------------------------------------------------------------------------------------------
   -- Baud Rate Generator.
   -- Create a clock enable that is BAUD_MULT_G x the baud rate.
   -- UartTx and UartRx use this.
   -------------------------------------------------------------------------------------------------
   U_UartBrg_1 : entity surf.UartBrg
      generic map (
         CLK_FREQ_G   => CLK_FREQ_G,
         BAUD_RATE_G  => BAUD_RATE_G,
         MULTIPLIER_G => BAUD_MULT_G)
      port map (
         clk       => CLK,              -- [in]
         rst       => reset,            -- [in]
         baudClkEn => UART_CLK);       -- [out]

   -------------------------------------------------------------------------------------------------
   -- UART Receiver
   -------------------------------------------------------------------------------------------------
   U_UartRx_1 : entity surf.UartRx
      generic map (
         TPD_G        => TPD_G,
         PARITY_G     => PARITY_G,
         BAUD_MULT_G  => BAUD_MULT_G,
         DATA_WIDTH_G => DATA_WIDTH_G)
      port map (
         clk       => CLK,              -- [in]
         rst       => reset,            -- [in]
         baudClkEn => UART_CLK,         -- [in]
         rdData    => uart_in,          -- [out]
         rdValid   => uart_in_valid,    -- [out]
         rdReady   => uart_in_ready,    -- [in]
         rx        => uartRX);          -- [in]

    uartRX <= UART_RXD;
    
ja1 <= uart_in_valid;
ja2 <= UART_RXD;
ja3 <= uart_in_ready;
--ja4 is a time multiplexed output of parallel data input
ja7 <= CLK;
ja8 <= reset;
ja9 <= UART_CLK;

end Behavioral;
