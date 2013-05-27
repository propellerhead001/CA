----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:19 05/09/2013 
-- Design Name: 
-- Module Name:    Controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( Instruction : in  STD_LOGIC_VECTOR (31 downto 0);
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  address : out STD_LOGIC_VECTOR (7 downto 0);
           RX : out  STD_LOGIC_VECTOR (4 downto 0);
           RA : out  STD_LOGIC_VECTOR (4 downto 0);
           RB : out  STD_LOGIC_VECTOR (4 downto 0);
			  shift : out STD_LOGIC_VECTOR (3 downto 0);
			  oen : out STD_LOGIC;
			  s34 : out STD_LOGIC_VECTOR(1 downto 0);
			  s1 : out STD_LOGIC_VECTOR (1 downto 0);
			  s2 : out STD_LOGIC_VECTOR (1 downto 0);
			  s5 : out STD_LOGIC;
			  s6 : out STD_LOGIC;
			  IMM : out  STD_LOGIC_VECTOR (15 downto 0);
			  AL : out STD_LOGIC_VECTOR (3 downto 0);
           regWri : out  STD_LOGIC;
           Flags : in  STD_LOGIC_VECTOR (7 downto 0));
end Controller;

architecture Behavioral of Controller is
COMPONENT ALUController
	PORT(
		Opcode : IN std_logic_vector(5 downto 0);
		alu_sig : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
		COMPONENT Sequencer
	PORT(
		Flags : IN std_logic_vector(7 downto 0);
		Conditions : IN std_logic_vector(7 downto 0);
		Offset : IN std_logic_vector(15 downto 0);
		Branch : IN std_logic;
		Jump : IN std_logic;
		clk : IN std_logic;
		rst : IN std_logic;          
		Address : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	type reg_delay is array(3 downto 0) of STD_LOGIC_VECTOR(4 downto 0);
	signal RA_temp, RB_temp : STD_LOGIC_VECTOR(4 downto 0);
	signal s1_imm, branch, jump, reg_temp,s5_temp, s6_temp : STD_LOGIC;
	signal s1_temp, s2_temp : STD_LOGIC_VECTOR(1 downto 0);
	signal conditions : STD_LOGIC_VECTOR (7 downto 0);
	signal data_a, data_b : STD_LOGIC_VECTOR(2 downto 0);
	signal RX_delay : reg_delay;
begin
	--RX only ever has value Rx as such is left permanently mapped (register writes are handled using regWri)
	RX_delay(0) <= Instruction(4 downto 0);
	RX <= RX_delay(3);
	--allows Ry to be used as memory address, with or without immediate
	RA <= RA_temp;
	RA_temp <= "00000" when ((Instruction(31 downto 30) = "10") and (Instruction(27 downto 26) = "01")) else
			Instruction(9 downto 5);
	--allows Rx to be used to point to data to outputted to memory
	RB <= RB_temp;
	RB_temp <= Instruction(4 downto 0) when Instruction(31 downto 28)  = "1001" else
			Instruction(14 downto 10);
	--immediate is always mapped, ALU can ignore I0 anyway.
	IMM <= Instruction(25 downto 10);
	--ALU instructions are stored in a ROM (various groups of instructions require different
	--ALU instructions and it is far simpler to store them in a ROM than to have hugely complex multliplexers)
	Inst_ALUController: ALUController PORT MAP(
		Opcode => Instruction(31 downto 26),
		alu_sig => AL
	);
	Inst_Sequencer: Sequencer PORT MAP(
		Flags => flags,
		Conditions => conditions,
		Offset => Instruction(25 downto 10),
		Branch => branch,
		Jump => jump,
		clk => clk,
		rst => rst,
		Address => address
	);
	--sets shift value, ignored when shift is not operation
	shift <= Instruction(13 downto 10);
	s34(0) <= '1' when Instruction(31 downto 27) = "10000" else
				 '0';
	s34(1) <= '1' when ((Instruction(31 downto 26) = "100001") or (Instruction(31 downto 26) = "100101")) else
				 '0';
	--sets when an immediate instruction is issued, allows setting of switches
	with Instruction(31 downto 26) select s1_imm <= '1' when "000010",
															  '1' when "000011",
															  '1' when "010100",
															  '1' when "010101",
															  '1' when "010110",
															  '1' when "100001",
															  '1' when "100011",
															  '1' when "100101",
															  '1' when "100111",
															  '0' when others;
	
	--enables output to memory
	with Instruction(31 downto 28) select oen <= '1' when "1000",
															   '0' when others;
	--flags a jump operation
	jump <= '1' when Instruction(31 downto 26) = "111111" else
			  '0';
	--flags a branch operation
	branch <= '1' when Instruction(31 downto 26) = "110001" else
			  '0';
	--selects the flags for branch instructions
	reg_write_delay : for i in 1 to 3 generate
		process(clk,rst)
		begin
			if(rising_edge(clk)) then
				if(rst = '1') then
					RX_delay(i) <= "00000";
				else
					RX_delay(i) <= RX_delay(i-1);
				end if;
			end if;
		end process;
		data_a(i-1) <= '1' when	(RA_temp = RX_delay(i)) else
							'0';
		data_b(i-1) <= '1' when	(RB_temp = RX_delay(i)) else
							'0';
	end generate reg_write_delay;
	with data_b select s5_temp <= '1' when "001",
											'0' when others;
	s1 <= "01" when s1_imm = '1' else
			s1_temp;
	with data_b select s1_temp <= "10" when "100",
											"10" when "110",
											"10" when "111",
											"11" when "010",
											"11" when "011",
											"00" when others;
	s5 <= s5_temp;
	with data_b select s5_temp <= '1' when "001",
											'0' when others;
	s2 <= s2_temp;
	with data_a select s2_temp <= "10" when "100",
											"10" when "110",
											"10" when "111",
											"11" when "010",
											"11" when "011",
											"00" when others;
	s6 <= s6_temp;
	with data_a select s6_temp <= '1' when "001",
											'0' when others;
	--set the conditions for branch instructions
	with Instruction(28 downto 26) select conditions <= "00000001" when "000",
																		  "00000010" when "001",
																		  "00000100" when "010",
																		  "00001000" when "011",
																		  "00010000" when "100",
																		  "00100000" when "101",
																		  "01000000" when "110",
																		  "10000000" when "111",
																		  "00000000" when others;
	regWri <=reg_temp;
	--sets the write flag for an instruction
	with Instruction(31 downto 26) select reg_temp <= '1' when "000000",
																	 '1' when "000001",
																	 '1' when "000010",
																	 '1' when "000011",
																	 '1' when "000100",
																	 '1' when "000101",
																	 '1' when "010000",
																	 '1' when "010001",
																	 '1' when "010010",
																	 '1' when "010011",
																	 '1' when "010100",
																	 '1' when "010101",
																	 '1' when "010110",
																	 '1' when "011000",
																	 '1' when "011001",
																	 '1' when "011010",
																	 '1' when "011011",
																	 '1' when "100000",
																	 '1' when "100001",
																	 '1' when "100010",
																	 '1' when "100011",
																	 '0' when others;
end Behavioral;

