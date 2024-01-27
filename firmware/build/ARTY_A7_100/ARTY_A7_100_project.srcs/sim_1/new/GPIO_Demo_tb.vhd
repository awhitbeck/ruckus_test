----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2024 09:15:53 PM
-- Design Name: 
-- Module Name: GPIO_Demo_tb - Behavioral
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

entity GPIO_Demo_tb is
--  Port ( );
end GPIO_Demo_tb;

architecture Behavioral of GPIO_Demo_tb is
component GPIO_demo
    Generic(
      TPD_G             : time                  := 1 ns;
      CLK_FREQ_G        : real                  := 100.0e6;
      BAUD_RATE_G       : integer               := 9600;
      BAUD_MULT_G       : integer range 1 to 16 := 16;
      STOP_BITS_G       : integer range 1 to 2  := 1;
      PARITY_G          : string                := "NONE";  -- "NONE" "ODD" "EVEN"
      DATA_WIDTH_G      : integer range 5 to 8  := 8);


    Port ( 
CLK 			: in  STD_LOGIC;
           LED 			: out  STD_LOGIC_VECTOR (3 downto 0);
           ja1          : out STD_LOGIC;
           ja2          : out STD_LOGIC;
           ja3          : out STD_LOGIC;
           ja4          : out STD_LOGIC;
           ja7          : out STD_LOGIC;
           ja8          : out STD_LOGIC;
           ja9          : out STD_LOGIC;
           UART_RXD 	: in  STD_LOGIC
             );
end component;

signal ja1_local : std_logic := '0';
signal ja2_local : std_logic := '0';
signal ja3_local : std_logic := '0';
signal ja4_local : std_logic := '0';
signal ja7_local : std_logic := '0';
signal ja8_local : std_logic := '0';
signal ja9_local : std_logic := '0';
signal uart_local: std_logic := '1';
signal led_local : std_logic_vector(3 downto 0) := "0000";
signal clk_local : std_logic := '0';

begin

    generate_clock : process 
    begin
        wait for 5 ns;
        clk_local <= not clk_local;        
    end process;

    DUT : GPIO_Demo
        Port map(
            CLK => clk_local,
            LED => led_local,
            ja1 => ja1_local, ja2 => ja2_local, ja3 => ja3_local, ja4 => ja4_local,
            ja7 => ja7_local, ja8 => ja8_local, ja9 => ja9_local, 
            UART_RXD => uart_local
        );

    UART_STIM : process(ja9_local)
    variable count : natural := 0;
    variable multiplier_count : natural := 0;
    variable output : std_logic_vector(31 downto 0) := "11111111111111001001111011111111"; -- 3F
    begin
        if rising_edge(ja9_local) then
            multiplier_count := multiplier_count+1;
            if multiplier_count > 15 then
                multiplier_count := 0;
                count := count+1;
                if count > 31 then 
                    count := 0;
                end if;
                uart_local <= output(count);    
            end if;
        end if;    
    end process;


end Behavioral;
