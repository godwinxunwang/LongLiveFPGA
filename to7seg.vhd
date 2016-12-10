----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:53:02 10/23/2016 
-- Design Name: 
-- Module Name:    to7seg - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity to7seg is
port(
     d0, d1, d2, d3, d4, d5, d6, d7: in STD_LOGIC_VECTOR(3 downto 0);
	  clk: in STD_LOGIC;
	  a: out STD_LOGIC_VECTOR(7 downto 0);
	  c: out STD_LOGIC_VECTOR(6 downto 0));
end to7seg;

architecture Behavioral of to7seg is

signal q0, q1, q2, q3, q4, q5, q6, q7: STD_LOGIC_VECTOR(6 downto 0);
signal cnt: STD_LOGIC_VECTOR(12 downto 0):= (OTHERS => '0');

component to7seg_single
port (
d_in: in STD_LOGIC_VECTOR(3 downto 0);
q: out STD_LOGIC_VECTOR(6 downto 0));
end component;

begin

  led0: to7seg_single port map(d_in => d0, q => q0);
  led1: to7seg_single port map(d_in => d1, q => q1);
  led2: to7seg_single port map(d_in => d2, q => q2);
  led3: to7seg_single port map(d_in => d3, q => q3);
  led4: to7seg_single port map(d_in => d4, q => q4);
  led5: to7seg_single port map(d_in => d5, q => q5);
  led6: to7seg_single port map(d_in => d6, q => q6);
  led7: to7seg_single port map(d_in => d7, q => q7);
  
  process(clk) begin
    if (clk'EVENT and clk='1') then	cnt <= cnt + 1; end if;
  end process;

      with cnt(12 downto 10) select
	     a <= "11111110" when "000",
		       "11111101" when "001",
		       "11111011" when "010",
		       "11110111" when "011",
		       "11101111" when "100",
		       "11011111" when "101",
		       "10111111" when "110",
		       "01111111" when "111",
		       "11111111" when others;
    
	   with cnt(12 downto 10) select
	     c <= q0 when "000",
		       q1 when "001",
		       q2 when "010",
		       q3 when "011",
		       q4 when "100",
		       q5 when "101",
		       q6 when "110",
		       q7 when "111",
		       (OTHERS => '0') when others;
			

end Behavioral;

