library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataMemory is
  port (
    clk  	: IN  std_logic;
	 rst     : IN  std_logic;
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

  process(clk, rst) begin
    if rst = '1' then ram <= (OTHERS => (OTHERS => '0'));
	                   ram(100) <= "10110111111000010101000101100011";
	                   ram(101) <= "01010110000110001100101100011100";
		                ram(102) <= "11110100010100000100010011010101";
		                ram(103) <= "10010010100001111011111010001110";
		                ram(104) <= "00110000101111110011100001000111";
		                ram(105) <= "11001110111101101011001000000000";
		                ram(106) <= "01101101001011100010101110111001";
		                ram(107) <= "00001011011001011010010101110010";
		                ram(108) <= "10101001100111010001111100101011";
		                ram(109) <= "01000111110101001001100011100100";
							 ram(110) <= "11100110000011000001001010011101";
							 ram(111) <= "10000100010000111000110001010110";
							 ram(112) <= "00100010011110110000011000001111";
							 ram(113) <= "11000000101100100111111111001000";
							 ram(114) <= "01011110111010011111100110000001";
							 ram(115) <= "11111101001000010111001100111010";
							 ram(116) <= "10011011010110001110110011110011";
							 ram(117) <= "00111001100100000110011010101100";
							 ram(118) <= "11010111110001111110000001100101";
							 ram(119) <= "01110101111111110101101000011110";
							 ram(120) <= "00010100001101101101001111010111";
							 ram(121) <= "10110010011011100100110110010000";
							 ram(122) <= "01010000101001011100011101001001";
							 ram(123) <= "11101110110111010100000100000010";
							 ram(124) <= "10001101000101001011101010111011";
							 ram(125) <= "00101011010011000011010001110100";
    elsif rising_edge(clk) then
      if wrtEn = '1' then ram(to_integer(unsigned(addr(9 downto 0)))) <= datain; end if;
    end if;
  end process;

  dataout <= ram(conv_integer(addr(9 downto 0)));
  display_out <= ram(conv_integer(i_cnt));

end architecture RTL;
