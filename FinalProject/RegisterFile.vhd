----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:55:46 12/01/2016 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use Ieee.STD_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( clk: in  STD_LOGIC;
			  Rs : in  STD_LOGIC_VECTOR (4 downto 0);
           Rt : in  STD_LOGIC_VECTOR (4 downto 0);
			  Rd : in  STD_LOGIC_VECTOR (4 downto 0);
           Wrt_Enable : in  STD_LOGIC;
			  write_data : in  STD_LOGIC_VECTOR (31 downto 0);
           Rs_data : out  STD_LOGIC_VECTOR (31 downto 0);
           Rt_date : out  STD_LOGIC_VECTOR (31 downto 0)
           );
end RegisterFile;

architecture Behavioral of RegisterFile is

type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
signal registers : registerFile(0 to 31):=(x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000");

begin

    regFile: process(clk)
    begin
        if rising_edge(clk) then 
            if(Wrt_Enable = '1') then
                registers(to_integer(unsigned(Rd))) <= write_data;
            end if;
            if falling_edge(clk) then
                Rs_data <= registers(to_integer(unsigned(Rs)));
                Rt_data <= registers(to_integer(unsigned(Rt)));
            end if;
        end if;
        if falling_edge(clk) then
                Rs_data <= registers(to_integer(unsigned(Rs)));
                Rt_data <= registers(to_integer(unsigned(Rt)));
        end if;
    end process;
	 
end behavioral;


