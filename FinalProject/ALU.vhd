library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.ALL;

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
			alu_out <= 0; 
		elsif(clk'event and clk='1') then 
			-- R-type instruction -- 
			if(opcode = "000000") then 
				case funct is 
					when x"10" => 
						alu_out <= op1 + op2; -- signed??? overflow??? raise the exception?? How? 
					when x"11" => 
						alu_out <= op1 - op2; -- signed??? overflow??? raise the exception?? How? 
					when x"12" => 
						alu_out <= op1 AND op2; -- not sure ?? 
					when x"13" => 
						alu_out <= op1 OR op2; -- not sure ??
					when x"14" => 
						alu_out <= NOT(op1 OR op2); 
				end case; 
			-- J-type instruction -- 
			elsif(opcode = "001100") then -- PC = {(PC + 4)[31:28], address, 00}
				-- Should PC be part of the ALU? 
				
			
			
			elsif(opcode = "111111") then -- Halt
			
			
			
			-- I-type instruction -- 
			else
				case opcode is 
					when 1 => -- addi
						alu_out <= op1 + op2;
					when 2 => -- subi
						alu_out <= op1 - op2; 
					when 3 => -- andi
						alu_out <= op1 AND op2; 
					when 4 => -- ori
						alu_out <= op1 OR op2; 
					when 5 => -- shl
						alu_out <= std_logic_vector(unsigned(op1) sll unsigned(op2)); 
					when 6 => -- shr
						alu_out <= std_logic_vector(unsigned(op1) srl unsigned(op2)); 
					when 7 => -- lw

					when 8 => -- sw
					
					when 9 => -- blt
					
					when 10 => -- beq
						if(op1 = op2) then
							alu_out <= 1; 
						else
							alu_out <= 0; 
						end if; 
					when 11 => -- bne
						if(op1 = op2) then 
							alu_out <= 0; 
						else 
							alu_out <= 1; 
						end if; 
				end case; 
			end if; 
		end if; 
	end process; 
end Behavioral;

