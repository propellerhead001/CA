--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:15:19 03/08/2013
-- Design Name:   
-- Module Name:   C:/Users/rjm529/CA/Lab2/Arch_d_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: arch_d
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.DigEng.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY Arch_d_test IS
	generic(Reg_Num : integer := 8;
			  size : integer := 16);
END Arch_d_test;
 
ARCHITECTURE behavior OF Arch_d_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT arch_d
    Generic(Reg_Num : integer;
			  size : integer);
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
    END COMPONENT;
    

   --Inputs
   signal imm : signed (size-1 downto 0);
   signal mem_in : signed (size-1 downto 0);
	signal mem_a : unsigned (size-1 downto 0);
   signal s5634 : STD_LOGIC_VECTOR (3 downto 0);
	signal s1 : STD_LOGIC_VECTOR(1 downto 0);
	signal s2 : STD_LOGIC_VECTOR(1 downto 0);
   signal RA : STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
   signal RB : STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
   signal W_EN : STD_LOGIC;
   signal WA : STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
   signal shift : unsigned (log2(size)-1 downto 0);
   signal al : unsigned (3 downto 0);
	signal clk : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal oen : STD_LOGIC;

 	--Outputs
   signal mem_out : signed (size-1 downto 0);
	signal mem_addr : unsigned (size-1 downto 0);
	signal flags : unsigned (7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: arch_d
	GENERIC MAP (Reg_Num => Reg_Num, size => size)
	PORT MAP (
          imm => imm,
          mem_in => mem_in,
          mem_a => mem_a,
          s5634 => s5634,
          s1 => s1,
          s2 => s2,
          RA => RA,
          RB => RB,
          W_EN => W_EN,
          WA => WA,
          shift => shift,
          al => al,
          clk => clk,
          rst => rst,
          oen => oen,
          mem_out => mem_out,
          mem_addr => mem_addr,
          flags => flags
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1';
		wait for clk_period*2;
		rst <= '0';
		wait for clk_period*1;
		--1
		ra <= "000"; --first operation reg read
		s1 <= "00";
		s2 <= "00";
		s5634 <="0000";
		oen <= '0';
		w_en <= '0';
		wait for clk_period*1;
		--2
		al <= "1000"; --first operation arithmetic
		ra <= "000"; -- second operation reg read
		wait for clk_period*1;
		--3
		w_en <= '1'; --first operation reg write
		wa <= "001";
		imm <= x"0005";--second operation arithmetic
		al <= "1010";
		s2 <= "01";
		s1 <= "11";--third operation reg read (avoid data hazard)
		rb <= "000";
		wait for clk_period*1;
		--4
		wa <= "010"; --second operation reg write
		w_en <= '1';
		al <= "1100"; --third operation arithmetic
		shift <= "0011";
		
		--5
		wa <= "010";
      wait;
   end process;

END;
