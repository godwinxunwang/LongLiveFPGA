library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all; 

entity ControlUnit is
port (
		clk: IN std_logic;
		clr: IN std_logic;
		Ins: IN std_logic_VECTOR(31 downto 0);
		RegDst: OUT std_logic;
		MemtoReg: OUT std_logic;		ALUOp: OUT std_logic_VECTOR(5 downto 0);		Memwrite: OUT std_logic;		Memread: OUT std_logic;
		ALUSrc:OUT std_logic;
		ALUfuc: OUT std_logic_VECTOR(5 downto 0);
		jump:OUT std_logic
);
end ControlUnit;

architecture Behavioral of ControlUnit is

SIGNAL  opcode : std_logic_VECTOR(3 downto 0);

begin 

opcode(3 downto 0) <= Ins(31 downto 28);
ALUop(5 downto 0)  <= Ins(31 downto 26);
ALUfuc(5 downto 0) <= Ins(5 downto 0);


with opcode select
RegDst <= '1' when "0000",
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
			 '0' when "1100",
			 '0' when others;
			 
with opcode select
MemtoReg<='0' when "0000",
          '0' when "0001",
			 '0' when "0010",
			 '0' when "0011",
			 '0' when "0100",
			 '0' when "0101",
			 '0' when "0110",
			 '1' when "0111",
			 '1' when "1000",
			 '0' when "1001",
			 '0' when "1010",
			 '0' when "1011",
			 '0' when "1100",
			 '0' when others;
			 
with opcode select
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
			 
with opcode select
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
			 
with opcode select
ALUSrc<=  '0' when "0000",
          '0' when "0001",
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
			 '0' when "1100",
			 '0' when others;
			 
with opcode select
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

end Behavioral;