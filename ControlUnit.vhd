library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all; 

entity ControlUnit is
port (
		Ins: IN std_logic_VECTOR(31 downto 0);
		RegDst: OUT std_logic;		Memwrite: OUT std_logic;		Memread: OUT std_logic;
		jump:OUT std_logic;
		ALUop: OUT std_logic_vector(5 downto 0);
		Branch: OUT std_logic_VECTOR(1 downto 0);
		R_Type: OUT std_logic
);
end ControlUnit;

architecture Behavioral of ControlUnit is

SIGNAL  opcode_1 : std_logic_VECTOR(3 downto 0);
SIGNAL  ALUfuc : std_logic_VECTOR(5 downto 0);
SIGNAL Adr_reg: std_logic_VECTOR(31 downto 0);

begin 

opcode_1(3 downto 0) <= Ins(29 downto 26);
ALUfuc<=Ins(5 downto 0);

with opcode_1 select
RegDst <= '0' when "0000",
          '1' when "0001",
			 '1' when "0010",
			 '1' when "0011",
			 '1' when "0100",
			 '1' when "0101",
			 '1' when "0110",
			 '1' when "0111",
			 '1' when "1000",
			 '1' when "1001",
			 '1' when "1010",
			 '1' when "1011",
			 '1' when "1100",
			 '1' when others;
			 
with opcode_1 select
Memwrite<='0' when "0000",
          '0' when "0001",
			 '0' when "0010",
			 '0' when "0011",
			 '0' when "0100",
			 '0' when "0101",
			 '0' when "0110",
			 '0' when "0111",
			 '1' when "1000",
			 '0' when "1001",
			 '0' when "1010",
			 '0' when "1011",
			 '0' when "1100",
			 '0' when others;
			 
with opcode_1 select
Memread<= '0' when "0000",
          '0' when "0001",
			 '0' when "0010",
			 '0' when "0011",
			 '0' when "0100",
			 '0' when "0101",
			 '0' when "0110",
			 '1' when "0111",
			 '0' when "1000",
			 '0' when "1001",
			 '0' when "1010",
			 '0' when "1011",
			 '0' when "1100",
			 '0' when others;
			 
with opcode_1 select
jump<=    '0' when "0000",
          '0' when "0001",
			 '0' when "0010",
			 '0' when "0011",
			 '0' when "0100",
			 '0' when "0101",
			 '0' when "0110",
			 '0' when "0111",
			 '0' when "1000",
			 '0' when "1001",
			 '0' when "1010",
			 '0' when "1011",
			 '1' when "1100",
			 '0' when others;
			 
with opcode_1 select
ALUop <=  ALUfuc  when "0000",
          "000000" when "0001",
			 "000000" when "0111",
			 "000000" when "1000",
			 "000001" when "0010",
			 "000010" when "0011",
			 "000011" when "0100",
			 "000101" when "1001",
			 "000110" when "1010",
			 "000000" when others;
			 
with opcode_1 select
Branch<= "01" when "1001",
"10" when "1010",
"11" when "1011",
"00" when others;


with opcode_1 select
R_Type<='1' when "0000",
'0' when others;


end Behavioral;