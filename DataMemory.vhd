library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataMemory is
  port (
    clk  	: IN  std_logic;
	 --rst     : IN  std_logic;
    wrtEn   : IN  std_logic;
    addr 	: IN  std_logic_vector(31 downto 0);
    datain  : IN  std_logic_vector(31 downto 0);
	 i_cnt   : IN  std_logic_vector(9 downto 0); -- for display
    dataout : OUT std_logic_vector(31 downto 0);
	 display_out: OUT std_logic_vector(31 downto 0) -- for display
  );
end entity DataMemory;

architecture RTL of DataMemory is

   type ram_type is array (1023 downto 0) of std_logic_vector(31 downto 0);
   signal ram : ram_type:= (OTHERS => (OTHERS => '0'));
   --signal read_address : std_logic_vector(31 downto 0):= (OTHERS => '0');

begin

  process(clk) is begin
    if rising_edge(clk) then
      if wrtEn = '1' then ram(to_integer(unsigned(addr))) <= datain; end if;
    end if;
  end process;

  dataout <= ram(conv_integer(addr(9 downto 0)));
  display_out <= ram(conv_integer(i_cnt));

end architecture RTL;
