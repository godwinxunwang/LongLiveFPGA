library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;

entity ALU is
	port(
		clr: in std_logic;
		clk: in std_logic; 
		op1: in std_logic_vector(31 downto 0); -- rs
		op2: in std_logic_vector(31 downto 0); -- rt / imm
		opcode: in std_logic_vector(5 downto 0); 
		funct: in std_logic_vector(5 downto 0); 
		alu_out: out std_logic_vector(31 downto 0)
	); 
end ALU;

architecture Behavioral of ALU is

begin
	process(clk, clr, opcode, funct) begin
		if(clr='1') then 
			alu_out <= x"00000000"; 
		elsif(clk'event and clk='1') then 
			-- R-type instruction -- 
			if(opcode = "000000") then 
				case funct is 
					when "010000" => 
						alu_out <= op1 + op2; -- signed??? overflow??? raise the exception?? How? 
					when "010001" => 
						alu_out <= op1 - op2; -- signed??? overflow??? raise the exception?? How? 
					when "010010" => 
						alu_out <= op1 AND op2; -- not sure ?? 
					when "010011" => 
						alu_out <= op1 OR op2; -- not sure ??
					when "010100" => 
						alu_out <= NOT(op1 OR op2); 
					when others => 
					
				end case; 
			-- J-type instruction -- 
			elsif(opcode = "001100") then -- PC = {(PC + 4)[31:28], address, 00}
				-- Should PC be part of the ALU? 
			
			elsif(opcode = "111111") then -- Halt
			
			-- I-type instruction -- 
			else
				case opcode is 
					when "000001" => -- addi
						alu_out <= op1 + op2;
					when "000010" => -- subi
						alu_out <= op1 - op2; 
					when "000011" => -- andi
						alu_out <= op1 AND op2; 
					when "000100" => -- ori
						alu_out <= op1 OR op2; 
					when "000101" => -- shl
						alu_out <= x"00000000"; 
						alu_out(31 downto to_integer(unsigned(op2))) <= op1((31- to_integer(unsigned(op2))) downto 0); 
					when "000110" => -- shr
						alu_out <= x"00000000";
						alu_out((31-to_integer(unsigned(op2))) downto 0) <= op1(31 downto to_integer(unsigned(op2)));
					when "001001" => -- blt
						if(op1 < op2) then 
							alu_out <= x"00000001"; 
						else
							alu_out <= x"00000000"; 
						end if; 
					when "001010" => -- beq
						if(op1 = op2) then
							alu_out <= x"00000001"; 
						else
							alu_out <= x"00000000"; 
						end if; 
					when "001011" => -- bne
						if(op1 = op2) then 
							alu_out <= x"00000000"; 
						else 
							alu_out <= x"00000001"; 
						end if; 
					when others => 
				end case; 
			end if; 
		end if; 
	end process; 
end Behavioral;

