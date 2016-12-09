library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity right_rotate_32bits is
  port (a: in STD_LOGIC_VECTOR(31 DOWNTO 0);
        b: in STD_LOGIC_VECTOR(5 DOWNTO 0);
		  o: out STD_LOGIC_VECTOR(31 DOWNTO 0));
end right_rotate_32bits;

architecture right_rotate of right_rotate_32bits is

begin
with b(4 downto 0) select
    o <= a(30 DOWNTO 0)&a(31) when "11111",
             a(29 DOWNTO 0)&a(31 DOWNTO 30) when "11110",
		       a(28 DOWNTO 0)&a(31 DOWNTO 29) when "11101",
		       a(27 DOWNTO 0)&a(31 DOWNTO 28) when "11100",
		       a(26 DOWNTO 0)&a(31 DOWNTO 27) when "11011",
		       a(25 DOWNTO 0)&a(31 DOWNTO 26) when "11010",
		       a(24 DOWNTO 0)&a(31 DOWNTO 25) when "11001",
		       a(23 DOWNTO 0)&a(31 DOWNTO 24) when "11000",
		       a(22 DOWNTO 0)&a(31 DOWNTO 23) when "10111",
		       a(21 DOWNTO 0)&a(31 DOWNTO 22) when "10110",
		       a(20 DOWNTO 0)&a(31 DOWNTO 21) when "10101",
		       a(19 DOWNTO 0)&a(31 DOWNTO 20) when "10100",
		       a(18 DOWNTO 0)&a(31 DOWNTO 19) when "10011",
		       a(17 DOWNTO 0)&a(31 DOWNTO 18) when "10010",
	 	       a(16 DOWNTO 0)&a(31 DOWNTO 17) when "10001",
		       a(15 DOWNTO 0)&a(31 DOWNTO 16) when "10000",
		       a(14 DOWNTO 0)&a(31 DOWNTO 15) when "01111",
		       a(13 DOWNTO 0)&a(31 DOWNTO 14) when "01110",
		       a(12 DOWNTO 0)&a(31 DOWNTO 13) when "01101",
		       a(11 DOWNTO 0)&a(31 DOWNTO 12) when "01100",
		       a(10 DOWNTO 0)&a(31 DOWNTO 11) when "01011",
		       a(9 DOWNTO 0)&a(31 DOWNTO 10) when "01010",
		       a(8 DOWNTO 0)&a(31 DOWNTO 9) when "01001",
		       a(7 DOWNTO 0)&a(31 DOWNTO 8) when "01000",
		       a(6 DOWNTO 0)&a(31 DOWNTO 7) when "00111",
		       a(5 DOWNTO 0)&a(31 DOWNTO 6) when "00110",
		       a(4 DOWNTO 0)&a(31 DOWNTO 5) when "00101",
		       a(3 DOWNTO 0)&a(31 DOWNTO 4) when "00100",
		       a(2 DOWNTO 0)&a(31 DOWNTO 3) when "00011",
		       a(1 DOWNTO 0)&a(31 DOWNTO 2) when "00010",
		       a(0)&a(31 DOWNTO 1) when "00001",
		       a when others;

end right_rotate;