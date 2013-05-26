--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:46:55 03/08/2013
-- Design Name:   
-- Module Name:   C:/Users/rjm529/CA/Lab2/arch_c_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: arch_c
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
use work.DigEng.All;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY arch_c_test IS
	generic(Reg_Num : integer := 8;
			  size : integer := 16);
END arch_c_test;
 
ARCHITECTURE behavior OF arch_c_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT arch_c
		Generic(Reg_Num : integer;
			size : integer);
		Port ( imm : in  signed (size-1 downto 0);
         mem_in : in  signed (size-1 downto 0);
			pc_in : in  signed (size-1 downto 0);
			mem_a : in  unsigned (size-1 downto 0);
         s1234 : in  STD_LOGIC_VECTOR (3 downto 0);
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
			pc_out : out  signed (size-1 downto 0);
			mem_addr : out  unsigned (size-1 downto 0);
         flags : out  unsigned (7 downto 0)
		);
    END COMPONENT;
    

   --Inputs
   signal imm : signed (size-1 downto 0);
   signal mem_in : signed (size-1 downto 0);
	signal mem_a : unsigned (size-1 downto 0);
	signal pc_in : signed (size-1 downto 0);
   signal s1234 : STD_LOGIC_VECTOR (3 downto 0);
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
	signal pc_out : signed (size-1 downto 0);
	signal mem_addr : unsigned (size-1 downto 0);
   signal flags : unsigned (7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: arch_c
		GENERIC MAP (Reg_Num => Reg_Num, size => size)
		PORT MAP (
          imm => imm,
          mem_in => mem_in,
			 mem_a => mem_a,
          pc_in => pc_in,
          s1234 => s1234,
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
          pc_out => pc_out,
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
		wait for clk_period*1;
		--inc R1, R0;
			--step 1 Fetch
			oen <= '0';
			w_en <= '0';
			al <= "1000";
			S1234 <= "0010";
			pc_in <= x"00FF";
			wait for clk_period*1;
			--step 2  Read Reg
			ra <= "000";
			wait for clk_period*1;
			--step 3 ALU
			S1234 <= "0000";
			AL <= "1000";
			wait for clk_period*1;
			--step 4 Reg Write
			w_en <= '1';
			wa <= "001";
			S1234 <= "0000";
		wait for clk_period*1;
		--addi R2, R0, 0005;
			wait for clk_period*1;
			--step 1 Fetch
			oen <= '0';
			w_en <= '0';
			al <= "1000";
			S1234 <= "0010";
			pc_in <= x"0100";
			wait for clk_period*1;
			--step 2 Read Reg
			ra <= "000";
			wait for clk_period*1;
			--step 3 ALU
			imm <= x"0005";
			s1234 <= "0001";
			al <= "1010";
			wait for clk_period*1;
			--step 4 Reg Write
			wa <= "010";
			w_en <= '1';
			wait for clk_period*1;
			
		--shl R3, R1, 0003;
			wait for clk_period*1;
			--step 1 Fetch
			oen <= '0';
			w_en <= '0';
			al <= "1000";
			s1234 <= "0010";
			pc_in <= x"0101"	;
			wait for clk_period*1;
			--step 2 Read Reg
			ra <= "001";
			rb <= "000";
			wait for clk_period*1;
			--step 3 ALU
			s1234 <= "0000";
			al <= "1100";
			shift <= "0011";
			wait for clk_period*1;
			--step 3 Reg Write
			wa <= "011";
			w_en <= '1';
		wait for clk_period*1;
		--storr R2, R3;
			wait for clk_period*1;
			--step 1 Fetch
			oen <= '0';
			w_en <= '0';
			al <= "1000";
			s1234 <= "0010";
			pc_in <= x"0102";
			wait for clk_period*1;
			--step 2 Read Reg
			ra <= "011";
			rb <= "010";
			wait for clk_period*1;
			--ALU
			al <= "0000";
			wait for clk_period*1;
			--MEM Write
			s1234 <= "0000";
			oen <= '1';
		wait for clk_period*1;
		--loadi R5, 1f1f;
			wait for clk_period*1;
			mem_in <= to_signed(7, size); -- sets up the 'memory' to be read
			--step 1 Fetch
			oen <= '0';
			w_en <= '0';
			al <= "1000";
			s1234 <= "0010";
			pc_in <= x"0103";
			wait for clk_period*1;
			--step 2 MEM Read
			mem_a <= x"1f1f";
			s1234 <= "1100";
			mem_in <= to_signed(7, size);
			wait for clk_period*1;
			--step 3 Reg Write
			wa <= "101";
			w_en <= '1';
		wait for clk_period*1;
	wait;
   end process;

END;
