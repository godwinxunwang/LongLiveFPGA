library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity ALU is
	port(
		op1: in std_logic_vector(31 downto 0); 
		op2: in std_logic_vector(31 downto 0);
		opcode: in std_logic_vector(5 downto 0); 
		funct: in std_logic_vector(5 downto 0); 
		alu_out: out std_logic_vector(31 downto 0)
	); 
end ALU;

architecture Behavioral of ALU is

begin


end Behavioral;

