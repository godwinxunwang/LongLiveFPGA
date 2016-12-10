library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;

entity top is
	port(
		clr: in std_logic; 
		clk: in std_logic;
		sw: in std_logic_vector(15 downto 0);
		anode: out std_logic_vector(7 downto 0);
		cathod: out std_logic_vector(6 downto 0);
		led: out std_logic_vector(15 downto 0)
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
			 i_cnt   : IN  std_logic_vector(9 downto 0);
			 dataout : OUT std_logic_vector(31 downto 0);
			 display_out: OUT std_logic_vector(31 downto 0)
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
			rd2	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			-- for display --
			i_cnt :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			display_out: OUT STD_LOGIC_VECTOR(31 downto 0)
			);
	end component; 
	
	-- Program Counter -- 
	component PC
		port(		
			 CLOCK: IN std_logic;
			 CLEAR: IN std_logic;
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
			RegDst: OUT std_logic;			Memwrite: OUT std_logic;			Memread: OUT std_logic;
			jump:OUT std_logic;
			ALUop: OUT std_logic_vector(5 downto 0);
			Branch: OUT std_logic_VECTOR(1 downto 0);
			R_Type: OUT std_logic;
			RegWrite: OUT std_logic;
			Halt: OUT std_logic
		); 
	end component; 
	
	-- Compare --
	component Compare
	   port(
		   rs: in STD_LOGIC_VECTOR(31 downto 0);
		   rt: in STD_LOGIC_VECTOR(31 downto 0);
		   branch: in STD_LOGIC_VECTOR(1 downto 0);
		   isBranch: out STD_LOGIC
		);
	end component;
	
	-- LED Controller --
	component to7seg
	   port(
		   d0, d1, d2, d3, d4, d5, d6, d7: in STD_LOGIC_VECTOR(3 downto 0);
	      clk: in STD_LOGIC;
			a: out STD_LOGIC_VECTOR(7 downto 0);
			c: out STD_LOGIC_VECTOR(6 downto 0)
		);
	end component;
   
	--type state_type is (ST_INI, ST_DONE);
	--signal state: state_type:= ST_INI;
	
	signal display_counter: std_logic_vector(9 downto 0);
	signal data_rf: std_logic_vector(31 downto 0);
	signal data_dm: std_logic_vector(31 downto 0);
	signal led_7: std_logic_vector(31 downto 0);
	signal RC5_done: std_logic;
	
	signal alu_out: std_logic_vector(31 downto 0); 
	signal ALUop: std_logic_vector(5 downto 0);
	signal dataout: std_logic_vector(31 downto 0); 
	signal inst: std_logic_vector(31 downto 0); -- from IMem
	signal rd1, rd2: std_logic_vector(31 downto 0); 
	signal to_rd: std_logic_vector(4 downto 0);
	signal to_rd_data: std_logic_vector(31 downto 0);
	signal to_op2: std_logic_vector(31 downto 0); 
	signal to_PC, PC1, PC_out: std_logic_vector(31 downto 0); 
	signal Jump_PC, PC_Branch: std_logic_vector(31 downto 0);
	
	signal in_wrtEnableRF, out_wrtEnableRF: std_logic; -- wrtEnable of RF 
	
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
	signal isHalt: std_logic;

begin	
   --instruction <= to_PC; -- for test
	
	-- HALT instruction --
--	with inst select
--	  RC5_done <= '1' when "1111110000000000000000000000000",
--	              '0' when OTHERS;

	-- State Machine --
--	process(clk, clr) begin
--	  if (clr = '1') then state <= ST_INI;
--	  elsif (clk'EVENT and clk = '1') then
--	    case state is
--		   when ST_INI => if (RC5_done = '1') then state <= ST_DONE; else state <= ST_INI; end if;
--			when ST_DONE => state <= ST_DONE;
--		 end case;
--	  end if;
--	end process;
	
	-- Display --
   with sw(0) select
	  led_7 <= data_rf when '0',
	           data_dm when '1';
	  
	display_counter <= sw(10 downto 1);
	led <= sw;
	
	-- Component Mapping -- 
	ALUIST: ALU port map(
			op1 => rd1, 
			op2 => rd2, 
			funct => inst(5 downto 0), 
			alu_out => alu_out
			); 
			
	DMem: DataMemory port map(
			clk => clk,
			wrtEn => isStore, -- from Decoder, via FF 
			addr => alu_out,
			datain => rd2,
			i_cnt => display_counter, -- for display
			dataout => dataout, -- to write RF -- ¼ÓFF
			display_out => data_dm -- for display
			); 
			
	RF: Reg_32 port map(
			clk => clk, 
			rst => clr, 
			rs => inst(25 downto 21), 
			rt => inst(20 downto 16),  
			rd => to_rd, 
			wrtEn => out_wrtEnableRF, -- from Decoder via FF -- ¼ÓFF
			wrtDa => to_rd_data, -- from Dmem via FF 
			rd1 => rd1,
			rd2 => rd2,
			-- for display --
			i_cnt => display_counter(4 downto 0),
			display_out => data_rf
		); 
	
	Decoder: ControlUnit port map(
			Ins => inst, 
			RegDst => I_Type, -- I-Type
			ALUOp => ALUop, -- when R-type, func			Memwrite => isStore, -- isStore			Memread => isLoad, -- isLoad
			R_Type => R_Type, -- R-Type 
			jump => J_Type, -- J-Type
			Branch => branchCMD, -- to comparitor
			RegWrite => in_wrtEnableRF,
			Halt => isHalt
			);
			
	CompareIST: Compare port map(
	      rs => rd1,
		   rt => rd2,
		   branch => branchCMD,
		   isBranch => isBranch
			);
		
	PC_FF: PC port map(CLOCK => clk,CLEAR => clr, D => to_PC, Q => PC_out); 
	
	Instruction_mem: IMEM port map(addr => PC_out, Ins => inst);
	
	LEDController: to7seg port map(
	      d0 => led_7(3 downto 0),
         d1 => led_7(7 downto 4),
         d2 => led_7(11 downto 8),
			d3 => led_7(15 downto 12),
			d4 => led_7(19 downto 16),
			d5 => led_7(23 downto 20),
			d6 => led_7(27 downto 24),
			d7 => led_7(31 downto 28),
	      clk => clk,
			a => anode,
			c => cathod
			);
	
	-- MUX's -- 
	-- MUX before RFs -- 
	with I_Type select 
		from_I_Type_left <= inst(15 downto 11) when '1', 
					           inst(20 downto 16) when others; 
	
	-- MUX between RFs and ALU -- 
	--with I_Type select 
		--to_op2 <= signExtendedImm when '1', 
					--inst(20 downto 16) when others; 
	
	-- MUX after Dmem -- 
	with IsLoad select 
		from_IsLoad_mux <= dataout when '1',
								 alu_out when others;  
								 
	-- MUX to PC --
	process(J_Type, isBranch, PC_Branch, PC1, Jump_PC) begin
	    if (J_Type = '1') then to_PC <= Jump_PC;
		 elsif (isBranch = '1') then to_PC <= PC_Branch;
		 else to_PC <= PC1;
		 end if;
   end process;
	
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
			to_rd_data <= (others=>'0'); 
		elsif(clk'event and clk='1') then 
			to_rd_data <= from_IsLoad_mux; 
		end if; 
	end process;
	
	-- "Flip-flop" before RF wrt enable -- 
	process(clk, clr) begin
		if(clr='1') then 
			out_wrtEnableRF <= '0';
		elsif(clk'event and clk='1') then 
			out_wrtEnableRF <= in_wrtEnableRF;
		end if; 
	end process;
	
	-- Adder for PC -- 
	with isHalt select
	   PC1 <= PC_out when '1',
             PC_out + 1 when OTHERS;	
	
	-- Adder for Branch --
	PC_Branch <= PC1 + signExtendedImm;
	
	-- jump PC address --
	Jump_PC <= PC1(31 downto 26)&inst(25 downto 0);
	
	

end Behavioral;

