library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg_32 is
port (
	--clock and reset signal
	clk	: 	IN STD_LOGIC;
	rst	:	IN STD_LOGIC;
	--5 bit input register
	rs		:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	rd		:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	rt		:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	--write enable bit and write data
	wrtEn	:	IN STD_LOGIC;
	wrtDa	: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	--output 32 bit data
	rd1	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	rd2	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	--for display--
	i_cnt :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	display_out: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end Reg_32;

architecture Behavioral of Reg_32 is

--32*32bit register file
type regType is array(31 downto 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL reg : regType:= (OTHERS => (OTHERS => '0'));

begin


process(clk, rst)
begin
   if rst = '1' then reg(31 downto 1) <= (OTHERS => (OTHERS => '0'));
	elsif rising_edge(clk) then  -- write data
   	if wrtEn = '1' then reg(to_integer(unsigned(rd)))(31 downto 0) <= wrtDa(31 downto 0); 
		end if;
	end if;


end process;
-- &0 --
reg(0) <= (OTHERS => '0');

--output
rd1 <= reg(to_integer(unsigned(rs)));
rd2 <= reg(to_integer(unsigned(rt)));

--for display
display_out <= reg(conv_integer(i_cnt));

end Behavioral;

