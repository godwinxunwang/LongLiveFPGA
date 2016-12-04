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
			D,CLOCK: in std_logic;
			Q: out std_logic
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

