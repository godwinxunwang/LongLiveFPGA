--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package My_package is

type Dram is array (0 to 1024) of std_logic_vector(7 downto 0);
type Regfile is array (0 to 31) of std_logic_vector(31 downto 0);


end package;

