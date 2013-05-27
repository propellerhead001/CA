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

entity arch_d is
	 Generic(Reg_Num : integer := 32;
				size : integer := 16);
    Port ( imm : in  signed (size-1 downto 0);
           mem_in : in  signed (size-1 downto 0);
			  mem_a : in  unsigned (size-1 downto 0);
           s5634 : in  STD_LOGIC_VECTOR (3 downto 0);
			  s1 : in STD_LOGIC_VECTOR(1 downto 0);
			  s2 : in STD_LOGIC_VECTOR(1 downto 0);
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
end arch_d;

architecture Behavioral of arch_d is
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
	COMPONENT dflip
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		en : IN std_logic;
		input : IN std_logic;          
		output : OUT std_logic
		);
	END COMPONENT;
	
	signal Ac, Bc, Ai, Bi, Ak, Bk, Ah, Bh, reg_in, alu_out, alu_i, alu_reg : signed (size-1 downto 0);
	signal mem_reg, mem_reg_out : signed (size-1 downto 0);
	
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
		A => Ak,
		B => Bk,
		fsel => al,
		shift => shift,
		S => alu_out,
		flags => flags
	);
	reg_A : for j in 0 to size - 1 generate
			reg_A: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => '1',
				input => Ac(j),
				output => Ah(j)
			);
		end generate;
	reg_B : for j in 0 to size - 1 generate
			reg_B: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => '1',
				input => Bc(j),
				output => Bh(j)
			);
	end generate;
	reg_alu_i : for j in 0 to size - 1 generate
			reg_alu_i: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => '1',
				input => alu_out(j),
				output => alu_i(j)
			);
	end generate;
	reg_alu : for j in 0 to size - 1 generate
			reg_alu: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => '1',
				input => alu_i(j),
				output => alu_reg(j)
			);
	end generate;
	reg_mem_in : for j in 0 to size - 1 generate
			reg_mem_in: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => '1',
				input => mem_in(j),
				output => mem_reg(j)
			);
	end generate;
	reg_mem_out : for j in 0 to size - 1 generate
			reg_mem_out: dflip PORT MAP(
				clk => clk,
				rst => rst,
				en => '1',
				input => Bh(j),
				output => mem_reg_out(j)
			);
	end generate;
	
	Ak <= alu_i when s1 = "10" else
			reg_in when s1 = "11" else
			Ah;	
	Bk <= alu_i when s2 = "10" else
			reg_in when s2 = "11" else
			imm when s2 = "01" else
			Bh;
	
	reg_in <= mem_reg when s5634(3) = '1' else
				 alu_reg;
	mem_out <= mem_reg_out when oen = '1' else
				  (others => 'Z');
	mem_addr <= unsigned(std_logic_vector(alu_i)) when s5634(2) = '0' else
					mem_a;
	Ac <= Ai when s5634(1) = '0' else
			reg_in;
	Bc <= Bi when s5634(0) = '0' else
			reg_in;
	
end Behavioral;

