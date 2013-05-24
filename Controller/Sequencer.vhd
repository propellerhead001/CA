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
type state_type is (count, jump_s, branch_s, eval_branch);
signal state : state_type;
signal instruction,insruct_intermediate : integer;
begin
process(clk, rst)
begin
	if (rising_edge(clk)) then
	if (rst = '1') then
		state <= count;
	else
		if ((state = count)and (Jump = '1') and (Branch = '0'))then
			state <= jump_s;
		elsif((state = count)and (Jump = '0') and (Branch = '1'))then
			state <= branch_s;
		--the pipeline is designed to stall in the case of a branch instruction
		elsif(state = branch_s)then
			state <= eval_branch;
		elsif(((state = eval_branch)or (state = jump_s) )and (Jump = '1') and (Branch = '0')) then
			state <= jump_s;
		elsif(((state = eval_branch)or (state = jump_s) )and (Jump = '0') and (Branch = '1')) then
			state <= branch_s;
		elsif(((state = eval_branch)or (state = jump_s) )and (Jump = '0') and (Branch = '1')) then
			state <= count;
		end if;
	end if;
	end if;
end process;
insruct_intermediate  <= instruction + to_integer(signed(Offset));
--instruction never goes below 0
Address <= STD_LOGIC_VECTOR(to_unsigned(instruction,8));
process(clk, rst)
begin
	if (rising_edge(clk)) then
		if (rst = '1') then
			instruction <= 0;
		elsif(state <= count) then
			instruction <= instruction + 1;
		elsif(state <= jump_s) then
			--Ensure that the address is not negative.
			--More complicated architectures would have a handling routine 
			if(insruct_intermediate >-1)then
				instruction <= insruct_intermediate;
			end if;
		elsif(state = branch_s)then
			if(to_integer(unsigned(Flags and Conditions))>0) then
				--check conditions, handles the posibility of more than one match ie. >=0 will also flag =0 in some cases
				if(insruct_intermediate>-1) then
					instruction <= insruct_intermediate;
				end if;
			else
				instruction <= instruction + 1;
			end if;
		end if;
	end if;
end process;
end Behavioral;

