library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Compare is
port (rs: in STD_LOGIC_VECTOR(31 downto 0);
		rt: in STD_LOGIC_VECTOR(31 downto 0);
		branch: in STD_LOGIC_VECTOR(1 downto 0);
		isBranch: out STD_LOGIC);
end Compare;

architecture Behavioral of Compare is

begin
process(branch, rs, rt) begin
  case branch is
    when "01" => if (rs < rt) then isBranch <= '1'; else isBranch <= '0'; end if;
	 when "10" => if (rs = rt) then isBranch <= '1'; else isBranch <= '0'; end if;
	 when "11" => if (not(rs = rt)) then isBranch <= '1'; else isBranch <= '0'; end if;
	 when OTHERS => isBranch <= '0';
  end case;
end process;
end Behavioral;