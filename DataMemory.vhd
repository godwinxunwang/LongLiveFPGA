library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity DataMemory is
  port (
    clk  	: IN  std_logic;
    wrtEn   : IN  std_logic;
    addr 	: IN  std_logic_vector(31 downto 0);
    datain  : IN  std_logic_vector(31 downto 0);
    dataout : OUT std_logic_vector(31 downto 0)
  );
end entity DataMemory;

architecture RTL of DataMemory is

   type ram_type is array (1023 downto 0) of std_logic_vector(31 downto 0);
   signal ram : ram_type;
   signal read_address : std_logic_vector(31 downto 0);

begin

  process(clk) is

  begin
    if rising_edge(clk) then
      if wrtEn = '1' then
        ram(to_integer(unsigned(addr))) <= datain;
      end if;
      read_address <= addr;
    end if;
  end process;

  dataout <= ram(to_integer(unsigned(read_address)));

end architecture RTL;
