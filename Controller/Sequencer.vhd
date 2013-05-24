----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:57:42 05/24/2013 
-- Design Name: 
-- Module Name:    Sequencer - Behavioral 
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

entity Sequencer is
    Port ( Flags : in  STD_LOGIC_VECTOR (7 downto 0);
			  Conditions : in  STD_LOGIC_VECTOR (7 downto 0);
			  Offset : in STD_LOGIC_VECTOR (15 downto 0);
			  Branch : in STD_LOGIC;
			  Jump : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
           Address : out  STD_LOGIC_VECTOR (7 downto 0));
end Sequencer;

architecture Behavioral of Sequencer is
type state_type is (count, jump, branch, eval_branch);
signal state : state_type;
signal instruction : integer;
begin
process(clk, rst)
begin
	if (rising_edge(clk)) then
	if (rst = '1') then
		state <= count;
	else
		if ((state = count)and (jump = '1') and (break = '0'))then
			state <= jump;
		elsif((state = count)and (jump = '0') and (break = '1'))then
			state <= break;
		elsif(state = branch)then
			state <= eval_branch;
		elsif((state = eval_branch) or (state = jump)) then
			satte <= count;
		end if;
	end if;
	end if;
end process;

end Behavioral;

