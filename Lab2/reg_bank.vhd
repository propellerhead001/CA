----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:44:57 02/27/2013 
-- Design Name: 
-- Module Name:    reg_bank - Behavioral 
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
use work.DigEng.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_bank is
	 Generic(Reg_Num : integer := 8;
				size : integer := 16);
    Port ( Data_in : in  signed (size-1 downto 0);
           RA : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           RB : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           WA : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           W_EN : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  clk : in STD_LOGIC;
           A : out  signed (size-1 downto 0);
           B : out  signed (size-1 downto 0));
end reg_bank;

architecture Behavioral of reg_bank is
	COMPONENT dflip
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		en : IN std_logic;
		input : IN std_logic;          
		output : OUT std_logic
		);
	END COMPONENT;
	
	signal enable_lines : STD_LOGIC_VECTOR (Reg_Num-1 downto 0);
	type data_lines_array is array (Reg_Num - 1 downto 0) of signed(size-1 downto 0);
	signal data_lines : data_lines_array;
begin
		data_lines(0) <= (others => '0');
		A <= data_lines(0) when to_integer(unsigned(RA)) = 0 else
			  (others =>'Z');
			  
		B <= data_lines(0) when to_integer(unsigned(RB)) = 0 else
			  (others =>'Z');
	whole_reg : for i in 1 to (Reg_Num - 1) generate
		enable_lines(i) <= '1' when to_integer(unsigned(WA)) = i and W_EN = '1' else
								'0';
		A <= data_lines(i) when to_integer(unsigned(RA)) = i else
			  (others =>'Z');
			  
		B <= data_lines(i) when to_integer(unsigned(RB)) = i else
			  (others =>'Z');
		
		reg : for j in 0 to size - 1 generate
			Inst_dflip: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => enable_lines(i),
				input => Data_in(j),
				output => data_lines(i)(j)
			);
		end generate;
	end generate;
	
end Behavioral;

