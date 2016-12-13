library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;

entity top is
	port(
		btn: in std_logic_vector(4 downto 0); 
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
			 rst     : IN  std_logic;
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
			RegDst: OUT std_logic;
			Memwrite: OUT std_logic;
			Memread: OUT std_logic;
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
			letter: in STD_LOGIC_VECTOR(7 downto 0);
			a: out STD_LOGIC_VECTOR(7 downto 0);
			c: out STD_LOGIC_VECTOR(6 downto 0)
		);
	end component;
   
	-- Display Signals --
	signal display_counter: std_logic_vector(9 downto 0);
	signal data_rf: std_logic_vector(31 downto 0);
	signal data_dm: std_logic_vector(31 downto 0);
	signal led_7: std_logic_vector(39 downto 0);
	
	--signal RC5_done: std_logic;
	
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
	
	signal branchCMD: std_logic_VECTOR(1 downto 0); 
	
	-- MUX's signals -- 
	signal J_Type: std_logic; 
	signal I_Type: std_logic; 
	signal R_Type: std_logic; 
	signal isLoad: std_logic; 
	signal isStore: std_logic; 
	signal isBranch: std_logic; 
	signal isHalt: std_logic;
	
   -- State Machine Signals--
	type state_type is (ST_INI, ST_IN1, ST_IN2, ST_IN3, ST_IN4, ST_IN5, ST_IN6, 
	                    ST_IN7, ST_IN8, ST_WRT_EX_DATA1, ST_WRT_EX_DATA2, ST_WRT_EX_DATA3, 
							  ST_WRT_EX_DATA4, ST_CHOOSE_FUNC, ST_ENCODE, ST_DECODE, 
							  ST_WRT_EN_DATA1, ST_WRT_EN_DATA2, ST_CHOOSE_MODE, ST_START, ST_OP, 
							  ST_REPEAT, ST_DISPLAY);
	signal currentstate, nextstate: state_type:= ST_INI;
	
	-- Input Signals --
	signal in1, in2, in3, in4, in5, in6, in7, in8: std_logic_vector(15 downto 0);
	
	-- BU ZHI DAO JIAO SHEN ME SIGNALS!!!!!!!! --
	signal FSM_WrtEn: std_logic:= '0';
	signal FSM_Wrt_Addr: std_logic_vector(9 downto 0):= (OTHERS => '0');
	signal FSM_Wrt_Data: std_logic_vector(31 downto 0);
	signal isExpansion: std_logic:= '1';
	signal FSM_Wrt_i: std_logic_vector(1 downto 0):= "00";
	signal PC_clr: std_logic;
	signal to_Dmem_wrten: std_logic;
	signal to_Dmem_addr: std_logic_vector(31 downto 0);
   signal to_Dmem_data: std_logic_vector(31 downto 0);
	signal Data_Display: std_logic_vector(31 downto 0);
	
	-- Button Signals --
	signal clr: std_logic;
	signal left, center, right, down: std_logic;
	signal btnbuffer: std_logic_vector(4 downto 0); 
	signal btnx, btny: std_logic_vector(4 downto 0):= "00000";

begin

   PC_clr <= clr or down;
	
	-- Button --
	clr <= btnbuffer(0);
	right <= btnbuffer(1);
	center <= btnbuffer(2);
	left <= btnbuffer(3);
	down <= btnbuffer(4);
	
	process (clk, btn) begin
    btnx <= btn;
	 if (clk'EVENT and clk = '1') then btny <= btnx; end if;
   end process;
   btnbuffer <= btnx and (btnx xor btny);
	
	-- State Machine --
	process (clk, clr) begin
     if (clr = '1') then currentstate <= ST_INI;
	  elsif (clk'EVENT and clk = '1') then currentstate <= nextstate;
	  end if;
   end process;
	
	process (currentstate, center, left, right, down, isHalt) begin
     case currentstate is
       when ST_INI => if (center = '1') then nextstate <= ST_IN1;
		                else nextstate <= ST_INI;
							 end if;
		 when ST_IN1 => if (center = '1') then nextstate <= ST_IN2;
		                else nextstate <= ST_IN1;
							 end if;
	    when ST_IN2 => if (center = '1') then nextstate <= ST_IN3;
		                else nextstate <= ST_IN2;
							 end if;
		 when ST_IN3 => if (center = '1') then nextstate <= ST_IN4;
		                else nextstate <= ST_IN3;
							 end if;
		 when ST_IN4 => if (center = '1') then 
		                  if (isExpansion = '1') then nextstate <= ST_IN5;
								elsif (isExpansion = '0') then nextstate <= ST_WRT_EN_DATA1;
								end if;
							 else nextstate <= ST_IN4;
							 end if;
		 when ST_IN5 => if (center = '1') then nextstate <= ST_IN6;
		                else nextstate <= ST_IN5;
							 end if;
		 when ST_IN6 => if (center = '1') then nextstate <= ST_IN7;
		                else nextstate <= ST_IN6;
							 end if;
		 when ST_IN7 => if (center = '1') then nextstate <= ST_IN8;
		                else nextstate <= ST_IN7;
							 end if;
		 when ST_IN8 => if (center = '1') then nextstate <= ST_WRT_EX_DATA1;
		                else nextstate <= ST_IN8;
							 end if;
		 when ST_WRT_EX_DATA1 => nextstate <= ST_WRT_EX_DATA2;
		 when ST_WRT_EX_DATA2 => nextstate <= ST_WRT_EX_DATA3;
		 when ST_WRT_EX_DATA3 => nextstate <= ST_WRT_EX_DATA4;
		 when ST_WRT_EX_DATA4 => nextstate <= ST_CHOOSE_FUNC;
		 when ST_CHOOSE_FUNC => if (left = '1') then nextstate <= ST_ENCODE;
		                        elsif (right = '1') then nextstate <= ST_DECODE;
		                        else nextstate <= ST_CHOOSE_FUNC;
							         end if;
		 when ST_ENCODE => nextstate <= ST_IN1;
		 when ST_DECODE => nextstate <= ST_IN1;
		 when ST_WRT_EN_DATA1 => nextstate <= ST_WRT_EN_DATA2;
		 when ST_WRT_EN_DATA2 => nextstate <= ST_CHOOSE_MODE;
		 when ST_CHOOSE_MODE => if (left = '1' or right = '1') then nextstate <= ST_START;
										elsif (down = '1') then nextstate <= ST_CHOOSE_FUNC;
		                        else nextstate <= ST_CHOOSE_MODE;
							         end if;
		 when ST_START => nextstate <= ST_OP;
		 when ST_OP => if (isHalt = '1') then nextstate <= ST_DISPLAY;
		               elsif (down = '1') then nextstate <= ST_REPEAT;
		               else nextstate <= ST_OP;
							end if;
		 when ST_REPEAT => nextstate <= ST_CHOOSE_FUNC;
		 when ST_DISPLAY => if (down = '1') then nextstate <= ST_CHOOSE_FUNC;
		                    else nextstate <= ST_DISPLAY;
								  end if;
	  end case;
   end process;
	
	-- isExpansion --
	process (clk, clr) begin
	  if (clr = '1') then isExpansion <= '1';
	  elsif (clk'EVENT and clk = '1') then 
	    if (currentstate = ST_CHOOSE_FUNC) then isExpansion <= '0'; end if;
	  end if;
   end process;
	
	-- Input --
	process (clk, clr) begin
    if (clr = '1') then in1 <= (OTHERS => '0');
	                     in2 <= (OTHERS => '0');
								in3 <= (OTHERS => '0');
								in4 <= (OTHERS => '0');
								in5 <= (OTHERS => '0');
								in6 <= (OTHERS => '0');
								in7 <= (OTHERS => '0');
								in8 <= (OTHERS => '0');
	 elsif (clk'EVENT and clk = '1') then 
	   case currentstate is
		  when ST_IN1 => in1 <= sw;
		  when ST_IN2 => in2 <= sw;
		  when ST_IN3 => in3 <= sw;
		  when ST_IN4 => in4 <= sw;
		  when ST_IN5 => in5 <= sw;
		  when ST_IN6 => in6 <= sw;
		  when ST_IN7 => in7 <= sw;
		  when ST_IN8 => in8 <= sw;
		  when OTHERS => NULL;
		end case;
    end if;
  end process;
  
  -- Write Data --
  with currentstate select
    FSM_Wrt_Data <= in1&in2 when ST_WRT_EX_DATA1,
	                 in1&in2 when ST_WRT_EN_DATA1,
	                 in3&in4 when ST_WRT_EX_DATA2,
						  in3&in4 when ST_WRT_EN_DATA2,
						  in5&in6 when ST_WRT_EX_DATA3,
						  in7&in8 when ST_WRT_EX_DATA4,
						  x"00000000" when ST_CHOOSE_FUNC,
						  x"00000000" when ST_ENCODE, -- Choose encode
                    x"00000001" when ST_DECODE,	-- Choose decode	
                    x"00000001" when ST_START,     -- Start program	
                    x"00000001" when ST_REPEAT,	-- Repeat enc or dec
                    x"00000000" when ST_INI,	   			  
						  (OTHERS => '0') when OTHERS;
						  
  -- Write Enable --
  with currentstate select
    FSM_WrtEn <= '1' when ST_INI,
	              '1' when ST_WRT_EX_DATA1,
	              '1' when ST_WRT_EN_DATA1,
	              '1' when ST_WRT_EX_DATA2,
					  '1' when ST_WRT_EN_DATA2,
					  '1' when ST_WRT_EX_DATA3,
					  '1' when ST_WRT_EX_DATA4,
					  '1' when ST_CHOOSE_FUNC,
					  '1' when ST_ENCODE,
                 '1' when ST_DECODE,
					  '1' when ST_START,
					  '1' when ST_REPEAT,
					  '0' when OTHERS; 
  
  -- Write Address --
  with currentstate select
    FSM_Wrt_Addr <= -- User key for Key Expansion --
	                 "0110010000" when ST_WRT_EX_DATA1, -- DMEM[400]
	                 "0110010001" when ST_WRT_EX_DATA2, -- DMEM[401]
						  "0110010010" when ST_WRT_EX_DATA3, -- DMEM[402]
						  "0110010011" when ST_WRT_EX_DATA4, -- DMEM[403]
						  -- A and B for Enc and Dec --
						  "0100101100" when ST_WRT_EN_DATA1, -- DMEM[300]
						  "0100101101" when ST_WRT_EN_DATA2, -- DMEM[301]
						  "1000000000" when ST_ENCODE, -- DMEM[512]
						  "1000000000" when ST_DECODE, -- DMEM[512]
						  "1000000001" when ST_START, -- DMEM[513]
						  "1000000001" when ST_CHOOSE_FUNC, -- DMEM[513]
						  "1000000010" when ST_REPEAT, -- DMEM[514]
						  "1000000010" when ST_INI, -- DMEM[514]
						  (OTHERS => '1') when OTHERS;
						  
  
  -- LED Display --
  process (clk, clr) begin
    if (clr = '1') then led_7 <= (OTHERS => '0');
	 elsif (clk'EVENT and clk = '1') then 
	   case currentstate is
		  when ST_INI => led_7 <= (OTHERS => '0');  
		  when ST_IN1 => led_7 <= "0000000000000000000000000000000000000001";
		  when ST_IN2 => led_7 <= "0000000000000000000000000000000000000010";
		  when ST_IN3 => led_7 <= "0000000000000000000000000000000000000011";
		  when ST_IN4 => led_7 <= "0000000000000000000000000000000000000100";
		  when ST_IN5 => led_7 <= "0000000000000000000000000000000000000101";
		  when ST_IN6 => led_7 <= "0000000000000000000000000000000000000110";
		  when ST_IN7 => led_7 <= "0000000000000000000000000000000000000111";
		  when ST_IN8 => led_7 <= "0000000000000000000000000000000000001000";
		  when ST_WRT_EX_DATA1 => NULL;
		  when ST_WRT_EX_DATA2 => NULL;
		  when ST_WRT_EX_DATA3 => NULL;
		  when ST_WRT_EX_DATA4 => NULL;
		  when ST_CHOOSE_FUNC => led_7 <= "1111110011001001000000000101111000010000";
		  when ST_ENCODE => NULL;
		  when ST_DECODE => NULL;
		  when ST_WRT_EN_DATA1 => NULL;
		  when ST_WRT_EN_DATA2 => NULL;
		  when ST_CHOOSE_MODE => led_7 <= "1111110011001001000000000101111000100000";
        when ST_START => NULL;
		  when ST_OP => NULL;
		  when ST_REPEAT => NULL;
		  when ST_DISPLAY => led_7 <= "00000000"&Data_Display;
      end case;
    end if;
  end process;
						  
  -- MUXs --
  with currentstate select
    to_Dmem_wrten <= isStore when ST_OP,
                     FSM_WrtEn when OTHERS;

  with currentstate select
    to_Dmem_addr <= alu_out when ST_OP,
                    "0000000000000000000000"&FSM_Wrt_Addr when OTHERS;
 
  with currentstate select
    to_Dmem_data <= rd2 when ST_OP,
                    FSM_Wrt_Data when OTHERS;	 
							 
							
							 
---------------------------------------------------- Processor -------------------------------------------------------------------				 
		 
	-- Display --
   with sw(0) select
	  Data_Display <= data_rf when '0',
	                  data_dm when others;
	  
	display_counter <= sw(10 downto 1);
	led <= sw;
	

	-- Component Mapping -- 
	ALUIST: ALU port map(
			op1 => rd1, 
			op2 => to_op2, 
			funct => ALUop, 
			alu_out => alu_out
			); 
			
	DMem: DataMemory port map(
			clk => clk,
			rst => clr,
			wrtEn => to_Dmem_wrten, -- from Decoder, via FF 
			addr => to_Dmem_addr,
			datain => to_Dmem_data,
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
			wrtEn => out_wrtEnableRF, -- from Decoder via FF 
			wrtDa => from_IsLoad_mux, -- from IsLoad MUX 
			rd1 => rd1,
			rd2 => rd2,
			-- for display --
			i_cnt => display_counter(4 downto 0),
			display_out => data_rf
		); 
	
	Decoder: ControlUnit port map(
			Ins => inst, 
			RegDst => I_Type, -- I-Type
			ALUOp => ALUop, -- when R-type, func
			Memwrite => isStore, -- isStore
			Memread => isLoad, -- isLoad
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
		
	PC_FF: PC port map(CLOCK => clk,CLEAR => PC_clr, D => to_PC, Q => PC_out); 
	
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
			letter => led_7(39 downto 32),
			a => anode,
			c => cathod
			);
	
	-- MUX's -- 
	-- MUX before RFs -- 
	with I_Type select 
		from_I_Type_left <= inst(15 downto 11) when '1', 
					           inst(20 downto 16) when others; 
	
	-- MUX between RFs and ALU -- 
	with I_Type select 
		to_op2 <= signExtendedImm when '1', 
					 rd2 when others; 
	
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
	--process(clk, clr) begin
	--	if(clr='1') then 
	--		to_rd_data <= (others=>'0'); 
	--	elsif(clk'event and clk='1') then 
	--		to_rd_data <= from_IsLoad_mux; 
	--	end if; 
	--end process;
	
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

