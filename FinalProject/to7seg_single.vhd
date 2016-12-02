----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:53:42 10/23/2016 
-- Design Name: 
-- Module Name:    to7seg_single - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity to7seg_single is
port(
     d_in: in STD_LOGIC_VECTOR(3 downto 0);
	  q: out STD_LOGIC_VECTOR(6 downto 0));
end to7seg_single;

architecture Behavioral of to7seg_single is

begin
  process(d_in)
  begin
    case d_in is
	   when "0000" => q <= "0000001";
	   when "0001" => q <= "1001111";
		when "0010" => q <= "0010010";
		when "0011" => q <= "0000110";
		when "0100" => q <= "1001100";
		when "0101" => q <= "0100100";
		when "0110" => q <= "0100000";
		when "0111" => q <= "0001111";
		when "1000" => q <= "0000000";
		when "1001" => q <= "0000100";
		when "1010" => q <= "0001000";
		when "1011" => q <= "1100000";
		when "1100" => q <= "0110001";
		when "1101" => q <= "1000010";
		when "1110" => q <= "0110000";
		when "1111" => q <= "0111000";
		when others => q <= "1111111";
	 end case;
  end process;

end Behavioral;

