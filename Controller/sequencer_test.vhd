--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:02:19 05/24/2013
-- Design Name:   
-- Module Name:   C:/Users/Robert/Documents/GitHub/CA/Controller/sequencer_test.vhd
-- Project Name:  Controller
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Sequencer
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
 
ENTITY sequencer_test IS
END sequencer_test;
 
ARCHITECTURE behavior OF sequencer_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Sequencer
    PORT(
         Flags : IN  std_logic_vector(7 downto 0);
         Conditions : IN  std_logic_vector(7 downto 0);
         Offset : IN  std_logic_vector(15 downto 0);
         Branch : IN  std_logic;
         Jump : IN  std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         Address : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Flags : std_logic_vector(7 downto 0) := (others => '0');
   signal Conditions : std_logic_vector(7 downto 0) := (others => '0');
   signal Offset : std_logic_vector(15 downto 0) := (others => '0');
   signal Branch : std_logic := '0';
   signal Jump : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal Address : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Sequencer PORT MAP (
          Flags => Flags,
          Conditions => Conditions,
          Offset => Offset,
          Branch => Branch,
          Jump => Jump,
          clk => clk,
          rst => rst,
          Address => Address
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
		wait for clk_period *2;
		rst <= '0';
		wait for clk_period *2;
		Flags <= "00000001";
		Conditions <= "00000001";
		Offset <= STD_LOGIC_VECTOR(to_signed(15,16));
		Branch <= '1';
		wait for clk_period *2;
		Conditions <= "00000000";
		wait for clk_period *2;
		Flags <= "00000001";
		Conditions <= "00000001";
		Offset <= STD_LOGIC_VECTOR(to_signed(-15,16));
		Branch <= '1';
		wait for clk_period *2;
		Conditions <= "00000001";
		Branch <= '0';
		wait for clk_period *10;
		Jump <= '1';
		wait for clk_period;
		Jump <= '0';
      wait;
   end process;

END;
