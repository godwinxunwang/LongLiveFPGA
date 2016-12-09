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

component left_rotate_32bits
  port(a: in STD_LOGIC_VECTOR(31 DOWNTO 0);
       b: in STD_LOGIC_VECTOR(5 DOWNTO 0);
		 o: out STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
end component;
		 
component right_rotate_32bits
  port(a: in STD_LOGIC_VECTOR(31 DOWNTO 0);
       b: in STD_LOGIC_VECTOR(5 DOWNTO 0);
		 o: out STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
end component;
begin
  left_rotate: left_rotate_32bits 
  port map(a => op1,
           b => op2(5 downto 0),
		     o => shl
           );
	
  right_rotate: right_rotate_32bits 
  port map(a => op1,
           b => op2(5 downto 0),
		     o => shr
           );

  with funct(2 downto 0) select
	  alu_out <= op1 + op2 when "000",
	             op1 - op2 when "001",
				    op1 and op2 when "010",
				    op1 or op2 when "011",
				    op1 nor op2 when "100",
				    shl when "101",
				    shr when "110",
					 (OTHERS => '0') when others;
  
    
end Behavioral;

