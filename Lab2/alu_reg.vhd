----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:53:12 02/27/2013 
-- Design Name: 
-- Module Name:    alu_reg - Behavioral 
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

entity alu_reg is
	 Generic(Reg_Num : integer := 8;
				size : integer := 16);
    Port ( imm : in  signed (size-1 downto 0);
           mem_in : in  signed (size-1 downto 0);
           s134 : in  STD_LOGIC_VECTOR (2 downto 0);
           RA : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           RB : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           W_EN : in  STD_LOGIC;
           WA : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           shift : in  unsigned (log2(size)-1 downto 0);
           al : in  unsigned (3 downto 0);
			  clk : in  STD_LOGIC;
			  rst : in  STD_LOGIC;
			  oen : in STD_LOGIC;
			  mem_out : out  signed (size-1 downto 0);
			  mem_addr : out  unsigned (size-1 downto 0);
           flags : out  unsigned (7 downto 0));
end alu_reg;

architecture Behavioral of alu_reg is
	COMPONENT reg_bank
	Generic(Reg_Num : integer;
				size : integer);
    Port ( Data_in : in  signed (size-1 downto 0);
           RA : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           RB : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           WA : in  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
           W_EN : in  STD_LOGIC;
			  rst : in STD_LOGIC;
			  clk : in STD_LOGIC;
           A : out  signed (size-1 downto 0);
           B : out  signed (size-1 downto 0)
			 );
	END COMPONENT;
	
	COMPONENT alu
	Generic (N : integer);
	PORT(
		A : in  SIGNED (size-1 downto 0);
      B : in  SIGNED (size-1 downto 0);
      fsel : in  UNSIGNED (3 downto 0);
      shift : in  UNSIGNED (log2(size)-1 downto 0);
      S : out  SIGNED (size-1 downto 0);
      flags : out  UNSIGNED(7 downto 0));
	END COMPONENT;
	
	signal Ai, Bi, Bk, reg_in, alu_out : signed (size-1 downto 0);
	
begin
	
	Inst_reg_bank: reg_bank
	GENERIC MAP (
		Reg_Num => Reg_Num,
		size => size)
	PORT MAP(
		Data_in => reg_in,
		RA => RA,
		RB => RB,
		WA => WA,
		W_EN => W_EN,
		rst => rst,
		clk => clk,
		A => Ai,
		B => Bi
	);
	
	Inst_alu: alu
	GENERIC MAP(N=>size)
	PORT MAP(
		A => Ai,
		B => Bk,
		fsel => al,
		shift => shift,
		S => alu_out,
		flags => flags
	);
	Bk <= imm when s134(0) = '1' else
			Bi;
	reg_in <= mem_in when s134(2) = '1' else
				 alu_out;
	mem_out <= Bi when oen = '1' else
				  (others => 'Z');
	mem_addr <= unsigned(std_logic_vector(alu_out));
	
	
end Behavioral;

