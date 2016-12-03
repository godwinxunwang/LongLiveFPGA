----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:53 12/03/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
port (
      op1: in STD_LOGIC_VECTOR(31 downto 0);
		op2: in STD_LOGIC_VECTOR(31 downto 0);
		funct: in STD_LOGIC_VECTOR(5 downto 0);
		alu_out: out STD_LOGIC_VECTOR(31 downto 0));
end ALU;
	
architecture Behavioral of ALU is
signal shl, shr: STD_LOGIC_VECTOR(31 downto 0);
begin
  with funct(2 downto 0) select
	  alu_out <= op1 + op2 when "000",
	             op1 - op2 when "001",
				    op1 and op2 when "010",
				    op1 or op2 when "011",
				    op1 nor op2 when "100",
				    shl when "101",
				    shr when "110",
					 (OTHERS => '0') when others;
					 
  with op2(5 downto 0) select
     shl <= op1(30 downto 0)&'0' when "000001",
	         op1(29 downto 0)&"00" when "000010",
			   op1(28 downto 0)&"000" when "000011",
			   op1(27 downto 0)&"0000" when "000100",
			   op1(26 downto 0)&"00000" when "000101",
			   op1(25 downto 0)&"000000" when "000110",
			   op1(24 downto 0)&"0000000" when "000111",
			   op1(23 downto 0)&"00000000" when "001000",
			   op1(22 downto 0)&"000000000" when "001001",
			   op1(21 downto 0)&"0000000000" when "001010",
			   op1(20 downto 0)&"00000000000" when "001011",
			   op1(19 downto 0)&"000000000000" when "001100",
			   op1(18 downto 0)&"0000000000000" when "001101",
			   op1(17 downto 0)&"00000000000000" when "001110",
			   op1(16 downto 0)&"000000000000000" when "001111",
			   op1(15 downto 0)&"0000000000000000" when "010000",
			   op1(14 downto 0)&"00000000000000000" when "010001",
			   op1(13 downto 0)&"000000000000000000" when "010010",
			   op1(12 downto 0)&"0000000000000000000" when "010011",
			   op1(11 downto 0)&"00000000000000000000" when "010100",
			   op1(10 downto 0)&"000000000000000000000" when "010101",
			   op1(9 downto 0)&"0000000000000000000000" when "010110",
			   op1(8 downto 0)&"00000000000000000000000" when "010111",
			   op1(7 downto 0)&"000000000000000000000000" when "011000",
			   op1(6 downto 0)&"0000000000000000000000000" when "011001",
			   op1(5 downto 0)&"00000000000000000000000000" when "011010",
			   op1(4 downto 0)&"000000000000000000000000000" when "011011",
			   op1(3 downto 0)&"0000000000000000000000000000" when "011100",
			   op1(2 downto 0)&"00000000000000000000000000000" when "011101",
			   op1(1 downto 0)&"000000000000000000000000000000" when "011110",
			   op1(0)&"0000000000000000000000000000000" when "011111",
			   (OTHERS => '0') when OTHERS;
  with op2(5 downto 0) select
     shr <= '0'&op1(31 downto 1) when "000001",
	         "00"&op1(31 downto 2) when "000010",
			   "000"&op1(31 downto 3) when "000011",
			   "0000"&op1(31 downto 4) when "000100",
			   "00000"&op1(31 downto 5) when "000101",
			   "000000"&op1(31 downto 6) when "000110",
			   "0000000"&op1(31 downto 7) when "000111",
			   "00000000"&op1(31 downto 8) when "001000",
			   "000000000"&op1(31 downto 9) when "001001",
			   "0000000000"&op1(31 downto 10) when "001010",
			   "00000000000"&op1(31 downto 11) when "001011",
			   "000000000000"&op1(31 downto 12) when "001100",
			   "0000000000000"&op1(31 downto 13) when "001101",
			   "00000000000000"&op1(31 downto 14) when "001110",
			   "000000000000000"&op1(31 downto 15) when "001111",
			   "0000000000000000"&op1(31 downto 16) when "010000",
			   "00000000000000000"&op1(31 downto 17) when "010001",
			   "000000000000000000"&op1(31 downto 18) when "010010",
			   "0000000000000000000"&op1(31 downto 19) when "010011",
			   "00000000000000000000"&op1(31 downto 20) when "010100",
			   "000000000000000000000"&op1(31 downto 21) when "010101",
			   "0000000000000000000000"&op1(31 downto 22) when "010110",
			   "00000000000000000000000"&op1(31 downto 23) when "010111",
			   "000000000000000000000000"&op1(31 downto 24) when "011000",
			   "0000000000000000000000000"&op1(31 downto 25) when "011001",
			   "00000000000000000000000000"&op1(31 downto 26) when "011010",
			   "000000000000000000000000000"&op1(31 downto 27) when "011011",
			   "0000000000000000000000000000"&op1(31 downto 28) when "011100",
			   "00000000000000000000000000000"&op1(31 downto 29) when "011101",
			   "000000000000000000000000000000"&op1(31 downto 30) when "011110",
			   "0000000000000000000000000000000"&op1(31) when "011111",
			   (OTHERS => '0') when OTHERS;
end Behavioral;

