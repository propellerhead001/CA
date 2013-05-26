----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:47:25 02/18/2013 
-- Design Name: 
-- Module Name:    arith - Behavioral 
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

entity arith is
	 Generic ( n : integer := 16);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Control : in  STD_LOGIC_VECTOR (1 downto 0);
           Output : out  STD_LOGIC_VECTOR (n-1 downto 0);
			  Overflow : out STD_LOGIC);
end arith;

architecture Behavioral of arith is
signal Outputi : STD_LOGIC_VECTOR (n downto 0);
signal Ai, Bi, outp : integer;
begin
	Ai <= to_integer(signed(A));	--converts A to signed integer
	Bi <= to_integer(signed(B));	--converts B to signed integer
	outp <= (Ai + 1) when Control = "00" else	-- A + 1
			  (Ai - 1) when Control = "01" else	-- A - 1
			  (Ai + Bi) when Control = "10" else	-- A + B
			  (Ai - Bi) when Control = "11";	--A-B
	-- Outputi is n+1 bits long, this is because the second most significant bit will show if an overflow
	--has occured, the output of this unit is then truncated to 16 bits by removing the line (n-2) from the vector contected to the output line
	Outputi <= std_logic_vector(to_signed(outp, n+1));
	Output(n-1) <= Outputi(n);
	Output(n-2 downto 0) <= Outputi(n-2 downto 0);
	Overflow <= Outputi(n-1) when Outputi(n) = '0' else --switches based on sign of number
					not Outputi(n-1);	--negative number will havea '0' if there is an overflow
											--and a positive will have a '1'

end Behavioral;

