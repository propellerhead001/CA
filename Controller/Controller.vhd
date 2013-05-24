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
--use IEEE.NUMERIC_STD.ALL;

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
			  s1 : out STD_LOGIC;
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
	signal s_imm, branch, jump : STD_LOGIC;
	signal conditions : STD_LOGIC_VECTOR (7 downto 0);
begin
	--RX only ever has value Rx as such is left permanently mapped (register writes are handled using regWri)
	RX <= Instruction(4 downto 0);
	--allows Ry to be used as memory address, with or without immediate
	RA <= "00000" when ((Instruction(31 downto 30) = "10") and (Instruction(27 downto 26) = "01")) else
			Instruction(9 downto 5);
	--allows Rx to be used to point to data to outputted to memory
	RB <= Instruction(4 downto 0) when Instruction(31 downto 28)  = "1001" else
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
	shift <= Instruction(13 downto 10);
	s34(0) <= '1' when Instruction(31 downto 27) = "10000" else
				 '0';
	s34(1) <= '1' when ((Instruction(31 downto 26) = "100001") or (Instruction(31 downto 26) = "100101")) else
				 '0';
	with Instruction(31 downto 26) select s_imm <= '1' when "000010",
															  '1' when "000011",
															  '1' when "010100",
															  '1' when "010101",
															  '1' when "010110",
															  '1' when "100001",
															  '1' when "100011",
															  '1' when "100101",
															  '1' when "100111",
															  '0' when others;
	s1 <= s_imm;
	with Instruction(31 downto 28) select oen <= '1' when "1000",
															   '0' when others;
	jump <= '1' when Instruction(31 downto 26) = "110000" else
			  '0';
	branch <= '1' when Instruction(31 downto 26) = "110001" else
			  '0';
end Behavioral;

