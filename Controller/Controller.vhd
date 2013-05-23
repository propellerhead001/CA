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
           RX : out  STD_LOGIC_VECTOR (4 downto 0);
           RA : out  STD_LOGIC_VECTOR (4 downto 0);
           RB : out  STD_LOGIC_VECTOR (4 downto 0);
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

end Behavioral;

