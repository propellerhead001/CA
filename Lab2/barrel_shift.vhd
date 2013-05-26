----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:15:42 02/18/2013 
-- Design Name: 
-- Module Name:    barrel_shift - Behavioral 
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity barrel_shift is
    Generic ( n : integer := 16);
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0);
           B : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Control : in  STD_LOGIC_VECTOR (1 downto 0);
           Output : out  STD_LOGIC_VECTOR (n-1 downto 0));
end barrel_shift;


architecture behavioural of barrel_shift is
--carry internal signals and provide '0' or appropriate line when shifting
type int_sig_type is array (log2(n)+1 downto 0) of STD_LOGIC_VECTOR(3*n-1 downto 0);
signal int_sig : int_sig_type;
begin
	
	int_sig(0)(2*n -1 downto n) <= A;--Sets the first signal in the vector to the input value
	--chooses between '0' and A based on whether or not it is a shift or rotate
	int_sig(0) (3*n-1 downto 2 * n) <= (others => '0') when control(1) = '0' else 
													A;
		int_sig(0) (1*n-1 downto 0) <= (others => '0') when control(1) = '0' else
												 A;
	internal_sig : for i in 1 to log2(n) + 1 generate
	--chooses between '0' and A based on whether or not it is a shift or rotate
		int_sig(i) (3*n-1 downto 2 * n) <= (others => '0') when control(1) = '0' else
														int_sig(i-1)(2*n -1 downto n);
		int_sig(i) (1*n-1 downto 0) <= (others => '0') when control(1) = '0' else
												 int_sig(i-1)(2*n -1 downto n);
	end generate;
	
	barrel : for i in 0 to (log2(n))generate --each 'row' of shifts
		shift : for j in 0 to n-1 generate	--each 'column' of shifts
			int_sig (i+1) (j+n) <=	int_sig(i) (j+n+(i+1)) when Control(0) = '1' and B(i) = '1' else --choose right input
											int_sig(i) (j+n-(i+1)) when Control(0) = '0' and B(i) = '1' else --choose left input
											int_sig(i) (j+n);--no shift
		end generate;
	end generate;
	
	Output <= int_sig(log2(n)+1) (2*n -1 downto n); -- takes the data from the last element in the array

end behavioural;

