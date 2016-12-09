library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;

entity top is
	port(
		clr: in std_logic; 
		clk: in std_logic
	); 
end top;

architecture Behavioral of top is
	-- Components Declaration -- 
	-- ALU -- 
	component ALU
		port(		
			op1: in std_logic_vector(31 downto 0); -- rs
			op2: in std_logic_vector(31 downto 0); -- rt / imm
			funct: in std_logic_vector(5 downto 0); 
			alu_out: out std_logic_vector(31 downto 0)
			);
	end component; 

	-- Data Memory -- 
	component DataMemory
		port(		
			 clk  	: IN  std_logic;
			 wrtEn   : IN  std_logic;
			 addr 	: IN  std_logic_vector(31 downto 0);
			 datain  : IN  std_logic_vector(31 downto 0);
			 dataout : OUT std_logic_vector(31 downto 0)
			);
	end component; 
	
	-- Register Files -- 
	component Reg_32
		port(		
			clk	: 	IN STD_LOGIC;
			rst	:	IN STD_LOGIC;
			rs		:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			rd		:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			rt		:	IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			wrtEn	:	IN STD_LOGIC;
			wrtDa	: 	IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			rd1	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			rd2	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	end component; 
	
	-- Program Counter -- 
	component PC
		port(		
			 CLOCK: IN  std_logic;
			 D: IN  std_logic_vector(31 downto 0);
			 Q: OUT std_logic_vector(31 downto 0)
			);
	end component; 
	
	-- Instuction Memory -- 
	component IMEM 
		port( 
			addr: IN std_logic_VECTOR(31 downto 0);
			Ins: OUT std_logic_VECTOR(31 downto 0)
			); 
	end component; 
	
	-- Decoder -- 
	component ControlUnit 
		port(
			Ins: IN std_logic_VECTOR(31 downto 0);
			RegDst: OUT std_logic;
			jump:OUT std_logic;
			ALUop: OUT std_logic_vector(5 downto 0);
			Branch: OUT std_logic_VECTOR(1 downto 0);
			PC: OUT std_logic_vector(31 downto 0);
			Adr: In std_logic_vector(31 downto 0);
			R_Type: OUT std_logic
		); 
	end component; 

	signal alu_out: std_logic_vector(31 downto 0); 
	signal dataout: std_logic_vector(31 downto 0); 
	signal inst: std_logic_vector(31 downto 0); -- from IMem
	signal rd1, rd2: std_logic_vector(31 downto 0); 
	signal to_rd: std_logic_vector(4 downto 0);
	signal to_wrt_data: std_logic_vector(31 downto 0);
	signal to_op2: std_logic_vector(31 downto 0); 
	signal to_PC, adder_out, PC_out: std_logic_vector(31 downto 0); 
	
	signal wrtEnableRF, wrtEnableDM: std_logic; -- wrtEnable after FF 
	
	signal signExtendedImm: std_logic_vector(31 downto 0); 
	signal from_IsLoad_mux: std_logic_vector(31 downto 0); 
	signal from_I_Type_left: std_logic_vector(4 downto 0); 
	
	signal incPC: std_logic_vector(31 downto 0); 
	signal branchCMD: std_logic_VECTOR(1 downto 0); 
	
	-- MUX's signals -- 
	signal J_Type: std_logic; 
	signal I_Type: std_logic; 
	signal R_Type: std_logic; 
	signal isLoad: std_logic; 
	signal isStore: std_logic; 
	signal isBranch: std_logic; 

begin	
	-- Component Mapping -- 
	ALU: ALU port map(
			op1 => rd1, 
			op2 => rd2, 
			funct => inst(5 downto 0), 
			alu_out => alu_out
			); 
			
	DMem: DataMemory port map(
			clk => clk,
			wrtEn => wrtEnableDM, -- from Decoder, via FF 
			addr => alu_out,
			datain => rd2,
			dataout => dataout -- to write RF -- ��FF
			); 
			
	RF: Reg_32 port map(
			clk => clk, 
			rst => clr, 
			rs => inst(25 downto 21), 
			rt => inst(20 downto 16),  
			rd => to_rd, 
			wrtEn => wrtEnableRF, -- from Decoder via FF -- ��FF
			wrtDa => to_wrt_data, -- from Dmem via FF 
			rd1 => rd1,
			rd2 => rd2
		); 
	
	Decoder: ControlUnit port map(
			Ins => inst, 
			RegDst => I_Type, -- I-Type
			ALUOp => ALUop, -- when R-type, func
			R_Type => R_Type, -- R-Type 
			jump => J_Type, -- J-Type
			Branch => branchCMD, -- to comparitor
			PC => to_PC, -- Calculated new PC address 
			Adr => incPC -- PC + 4
			);
		
	PC: PC port map(CLOCK => clk, D => to_PC, Q => PC_out); 
	
	Imem: IMEM port map(addr => PC_out, Ins => inst);
	
	-- MUX's -- 
	-- MUX before RFs -- 
	with I_Type select 
		to_rd <= inst(15 downto 11) when '1', 
					inst(20 downto 16) when others; 
	
	-- MUX between RFs and ALU -- 
	--with I_Type select 
		--to_op2 <= signExtendedImm when '1', 
					--inst(20 downto 16) when others; 
	
	-- MUX after Dmem -- 
	with IsLoad select 
		from_IsLoad_mux <= dataout when '1',
								 alu_out when others;  
	
	-- Sign Extension -- 
	with inst(15) select
		signExtendedImm <= "1111111111111111" & inst(15 downto 0) when '1', 
								 "0000000000000000" & inst(15 downto 0) when others; 
	
	-- "Flip-flop" before Wrt Register -- 
	process(clk, clr) begin
		if(clr='1') then 
			to_rd <= "00000"; 
		elsif(clk'event and clk='1') then 
			to_rd <= from_I_Type_left; 
		end if; 
	end process; 
	
	-- "Flip-flop" before wrt data -- 
	process(clk, clr) begin
		if(clr='1') then 
			to_wrt_data <= (others=>'0'); 
		elsif(clk'event and clk='1') then 
			to_wrt_data <= from_IsLoad_mux; 
		end if; 
	end process;
	
	-- "Flip-flop" before wrt enable -- 
	process(clk, clr) begin
		if(clr='1') then 
			outWrtEnableFF <= '0'; 
		elsif(clk'event and clk='1') then 
			outWrtEnableFF <= inWrtEnableFF; 
		end if; 
	end process;
	
	-- Adder for PC -- 
	adder_out <= PC_out + 4; 
	
	

end Behavioral;
