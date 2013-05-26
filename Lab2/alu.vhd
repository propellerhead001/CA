library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.DigEng.ALL;

entity alu is
	 Generic (N : integer := 16);
    Port ( A : in  SIGNED (N-1 downto 0);
           B : in  SIGNED (N-1 downto 0);
           fsel : in  UNSIGNED (3 downto 0);
           shift : in  UNSIGNED (log2(N)-1 downto 0);
           S : out  SIGNED (N-1 downto 0);
           flags : out  UNSIGNED(7 downto 0));
end alu;

architecture Behavioral of alu is

signal ALUout : SIGNED (N-1 downto 0);
signal int_flags : UNSIGNED(7 downto 0);

begin

with fsel select
	ALUout <= 	A 						when "0000",
					A and B				when "0100",
					A or B				when "0101",
					A xor B				when "0110",
					not A 				when "0111",
					A + 1					when "1000",
					A - 1					when "1001",
					A + B					when "1010",
					A - B					when "1011",
					shift_left(A,to_integer(shift))		when "1100",
					shift_right(A,to_integer(shift)) 	when "1101",
					rotate_left(A,to_integer(shift)) 	when "1110",
					rotate_right(A,to_integer(shift))	when "1111",
					(others => 'X')	when others;

int_flags(0) <= '1' when (ALUout = 0) else '0';
int_flags(1) <= not int_flags(0);
int_flags(2) <= '1' when (ALUout = 1) else '0';
int_flags(3) <= '1' when (ALUout < 0) else '0';
int_flags(4) <= '1' when (ALUout > 0) else '0';
int_flags(5) <= not int_flags(4);
int_flags(6) <= not int_flags(3);
int_flags(7) <= '0'; -- Overflow not implemented

S <= ALUout;
flags <= int_flags;

end Behavioral;

