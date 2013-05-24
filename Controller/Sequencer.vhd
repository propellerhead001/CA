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
--use IEEE.NUMERIC_STD.ALL;

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
           Address : out  STD_LOGIC_VECTOR (7 downto 0));
end Sequencer;

architecture Behavioral of Sequencer is

begin


end Behavioral;

