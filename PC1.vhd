library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
PORT( 
			CLOCK: in std_logic;
			D: in std_logic_vector(31 downto 0);
			Q: out std_logic_vector(31 downto 0)
	  );
end PC;

architecture Behavioral of PC is

begin
	process(CLOCK)
		begin
			if(CLOCK='1' and CLOCK'EVENT) then Q <= D;
		end if;
	end process;
	
end Behavioral;

