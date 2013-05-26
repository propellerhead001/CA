--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:11:37 02/28/2013
-- Design Name:   
-- Module Name:   C:/Users/rjm529/CA/Lab2/reg_test.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg_bank
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY reg_test IS
END reg_test;
 
ARCHITECTURE behavior OF reg_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg_bank
    PORT(
         Data_in : IN  signed(15 downto 0);
         RA : IN  std_logic_vector(2 downto 0);
         RB : IN  std_logic_vector(2 downto 0);
         WA : IN  std_logic_vector(2 downto 0);
         W_EN : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         A : OUT  signed(15 downto 0);
         B : OUT  signed(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Data_in : signed(15 downto 0) := (others => '0');
   signal RA : std_logic_vector(2 downto 0) := (others => '0');
   signal RB : std_logic_vector(2 downto 0) := (others => '0');
   signal WA : std_logic_vector(2 downto 0) := (others => '0');
   signal W_EN : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal A : signed(15 downto 0);
   signal B : signed(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg_bank PORT MAP (
          Data_in => Data_in,
          RA => RA,
          RB => RB,
          WA => WA,
          W_EN => W_EN,
          rst => rst,
          clk => clk,
          A => A,
          B => B
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
		rst <='1';
		wait for clk_period*1;
		rst <='0';
		data_in <= (others => '1');
		wa <= "010";
		w_en <= '1';
		wait for clk_period*1;
		w_en <= '0';
		ra <= "010";
		rb <= "000";
		
		
      wait;
   end process;

END;
