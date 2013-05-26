--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:06:33 03/06/2013
-- Design Name:   
-- Module Name:   C:/Users/rjm529/CA/Lab2/reg_bank_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu_reg
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
 
ENTITY reg_bank_test IS
	generic(Reg_Num : integer := 8;
			  size : integer := 16);
END reg_bank_test;
 
ARCHITECTURE behavior OF reg_bank_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu_reg
    Generic(Reg_Num : integer;
				size : integer);
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
    END COMPONENT;
    

   --Inputs
   signal imm :  signed (size-1 downto 0);
   signal mem_in :  signed (size-1 downto 0);
   signal s134 :  STD_LOGIC_VECTOR (2 downto 0);
   signal RA :  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
   signal RB :  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
   signal W_EN :  STD_LOGIC;
   signal WA :  STD_LOGIC_VECTOR (log2(Reg_Num)-1 downto 0);
   signal shift :  unsigned (log2(size)-1 downto 0);
   signal al :  unsigned (3 downto 0);
	signal clk :  STD_LOGIC;
	signal rst :  STD_LOGIC;
	signal oen : STD_LOGIC;

 	--Outputs
   signal mem_out : signed(size-1 downto 0);
	signal mem_addr : unsigned (size-1 downto 0);
   signal flags : unsigned(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu_reg
		GENERIC MAP (Reg_Num => Reg_Num, size => size)
		PORT MAP (
          imm => imm,
          mem_in => mem_in,
          s134 => s134,
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
		wait for clk_period*1;
		rst <= '0';
		--inc R1, R0
		ra <= "000";
		al <= "1000";
		s134 <= "001";
		wa <= "001";
		w_en <= '1';
		rb <= "001";
		oen <= '0';
		wait for clk_period*3;
		--addi R2, R0,0005
		ra <= "000";
		al <= "1010";
		s134 <= "001";
		wa <= "010";
		w_en <= '1';
		rb <= "010";
		imm <= to_signed(5, size);
		wait for clk_period*3;
		--shl R3, R1, 0001
		ra <= "001";
		al <= "1100";
		shift <= "0011";
		wa <= "011";
		w_en <= '1';
		rb <= "011";
		wait for clk_period*3;
		--storr R2, R3
		ra <= "011";
		al <= "0000";
		w_en <= '0';
		rb <= "010";
		oen <= '1';
		wait for clk_period*3;
		--loadi R5, 1F1F
		ra <= "000";
		imm <= x"1F1F";
		s134 <= "101";
		mem_in <= to_signed(7, size);
		wa <= "101";
		
      wait;
   end process;

END;
