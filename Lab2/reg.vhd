----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:46 02/04/2013 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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

entity dflip is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  en : in STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end dflip;

architecture arch of dflip is
begin
flip: process (clk)
	begin
		if(rising_edge(clk))then
			if(rst = '1') then
				output <= '0';
			elsif (en = '1') then
				output <= input;
			end if;
		end if;
	end process flip;
end arch;

