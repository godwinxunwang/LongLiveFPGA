library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IMEM is
port (
addr: IN std_logic_VECTOR(31 downto 0);
Ins: OUT std_logic_VECTOR(31 downto 0)
);
end IMEM;


architecture Behavioral of IMEM is

TYPE rom IS ARRAY (0 TO 999) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
CONSTANT skey : rom:=rom'(x"04220001", x"fc000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000",
x"00000000", x"00000000",x"00000000",x"00000000",x"00000000", 
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000", x"00000000",x"00000000",
x"00000000",x"00000000", x"00000000",x"00000000",x"00000000");
SIGNAL I_cnt: std_logic_VECTOR(31 downto 0);


begin
I_cnt<= Addr;
--Ins<= skey(CONV_INTEGER(i_cnt ))&skey(CONV_INTEGER(i_cnt +"01"))&skey(CONV_INTEGER(i_cnt+"10" ))&skey(CONV_INTEGER(i_cnt+"11" ));
Ins <= skey(CONV_INTEGER(i_cnt));



end Behavioral;