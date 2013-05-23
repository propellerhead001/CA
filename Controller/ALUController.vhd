----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:23:16 05/09/2013 
-- Design Name: 
-- Module Name:    ALUController - Behavioral 
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

entity ALUController is
    Port ( Opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           alu_sig : out  STD_LOGIC_VECTOR (3 downto 0));
end ALUController;

architecture Behavioral of ALUController is
type ALU_Cont is array(0 to 63) of STD_LOGIC_VECTOR (3 downto 0);
constant ALU_Controller : ALU_Cont :=(
"1010", "1011", "1010", "1011", "1000", "1001", "0000", "0000", --0 to 7 Arithmetic
"0000",  "0000", "0000",  "0000", "0000",  "0000", "0000",  "0000",--8 to 15
"0000", "0100", "0110", "0111", "0000", "0100", "0110", "0000",--16 to 23 Logic
"1100", "1101", "1110", "1111", "0000",  "0000", "0000",  "0000",--24 to 31
"0000",  "0000", "0000",  "0000", "0000",  "0000", "0000",  "0000",--32 to 39 Transfer
"0000",  "0000", "0000",  "0000", "0000",  "0000", "0000",  "0000",--40 to 47
"0000",  "0000", "0000",  "0000", "0000",  "0000", "0000",  "0000",--48 to 55 Control
"0000",  "0000", "0000",  "0000", "0000",  "0000", "0000",  "0000");--56 to 63
begin
alu_sig <= ALU_Controller(to_integer(unsigned(Opcode)));
end Behavioral;

