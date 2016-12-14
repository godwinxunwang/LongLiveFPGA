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
CONSTANT skey : rom:=(
"00011100000011110000001000000001", 
"00101000000011111111111111111110", 
"00011100000011110000001000000010", 
"00101100000011110000000000100101", 
"00011100000001100000000110010000", 
"00011100000001110000000110010001", 
"00011100000010000000000110010010", 
"00011100000010010000000110010011", 
"00000000000000000000100000010000", 
"00000000000000000001000000010000", 
"00000000000000000001100000010000", 
"00000100000111100000000000011001", 
"00000100000111110000000000000011", 
"00000100000001110000000001001110", 
"00011100001100000000000001100100", 
"00000001010010111000100000010000", 
"00000010000100011001000000010000", 
"00010110010100110000000000000011", 
"00100000001100110000000001100100", 
"00011100001010100000000001100100", 
"00011100010110100000000011001000", 
"00000001010010111101100000010000", 
"00000011010110111110000000010000", 
"00001111011001000000000000011111", 
"00001000100001000000000000000001", 
"00010111100111000000000000000001", 
"00101100000001001111111111111101", 
"00100000010111000000000011001000", 
"00011100010010110000000011001000", 
"00101111110000010000000000000001", 
"00110000000000000000000000100001", 
"00000100001000010000000000000001", 
"00110000000000000000000000100010", 
"00000000000000000000100000010000", 
"00101111111000100000000000000001", 
"00110000000000000000000000100110", 
"00000100010000100000000000000001", 
"00110000000000000000000000100111", 
"00000000000000000001000000010000", 
"00000100011000110000000000000001", 
"00101100111000111111111111100101", 
"00011100000011110000001000000000", 
"00101000000011110000000000100100", 
"00011100000010000000000100101100", 
"00011100000010010000000100101101", 
"00011100000010100000000001100100", 
"00011100000010110000000001100101", 
"00000001000010100100000000010000", 
"00000001001010110100100000010000", 
"00000100001000010000000000000001", 
"00000000001000010001000000010000", 
"00000001000010001000000000010100", 
"00000001001010011000100000010100", 
"00000010000100011001000000010100", 
"00000001000010011001100000010100", 
"00000010010100111010000000010100", 
"00000000000010010010000000010000", 
"00001100100001000000000000011111", 
"00001000100001000000000000000001", 
"00010110100101000000000000000001", 
"00101100000001001111111111111101", 
"00011100010101100000000001100100", 
"00000010100101100100000000010000", 
"00000001000010001000000000010100", 
"00000001001010011000100000010100", 
"00000010000100011001000000010100", 
"00000001000010011001100000010100", 
"00000010010100111010000000010100", 
"00000000000010000001100000010000", 
"00001100011000110000000000011111", 
"00001000011000110000000000000001", 
"00010110011100110000000000000001", 
"00101100000000111111111111111101", 
"00011100010101100000000001100100", 
"00000010011101100100100000010000", 
"00001000001111110000000000001100", 
"00101111111000001111111111100100", 
"00100000000010000000001001011000", 
"00100000000010010000001001011001", 
"00011100000010000000000100101100", 
"00011100000010010000000100101101", 
"00011100000010100000000001100100", 
"00011100000010110000000001100101", 
"00000100000000010000000000001100", 
"00000000001000010001000000010000", 
"00011100010101100000000001100100", 
"00000001001101101011100000010001", 
"00000000000010000001100000010000", 
"00001100011000110000000000011111", 
"00001000011000110000000000000001", 
"00011010111101110000000000000001", 
"00101100000000111111111111111101", 
"00000001000010001000000000010100", 
"00000010111101111000100000010100", 
"00000010000100011001000000010100", 
"00000001000101111001100000010100", 
"00000010010100110100100000010100", 
"00011100010101100000000001100100", 
"00000001000101101011100000010001", 
"00000000000010010010000000010000", 
"00001100100001000000000000011111", 
"00001000100001000000000000000001", 
"00011010111101110000000000000001", 
"00101100000001001111111111111101", 
"00000001001010011000000000010100", 
"00000010111101111000100000010100", 
"00000010000100011001000000010100", 
"00000001001101111001100000010100", 
"00000010010100110100000000010100", 
"00001000001000010000000000000001", 
"00101100001000001111111111100101", 
"00000001001010110100100000010001", 
"00000001000010100100000000010001", 
"00100000000010000000001001011010", 
"00100000000010010000001001011011", 
"11111100000000000000000000000000", 
x"00000000",x"00000000",x"00000000", x"00000000",
x"00000000",x"00000000",x"00000000",x"00000000", x"00000000",
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