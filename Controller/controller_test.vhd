--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:49:29 05/25/2013
-- Design Name:   
-- Module Name:   C:/Users/Robert/Documents/GitHub/CA/Controller/controller_test.vhd
-- Project Name:  Controller
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Controller
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
--USE ieee.numeric_std.ALL;
 
ENTITY controller_test IS
END controller_test;
 
ARCHITECTURE behavior OF controller_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Controller
    PORT(
         Instruction : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         address : OUT  std_logic_vector(7 downto 0);
         RX : OUT  std_logic_vector(4 downto 0);
         RA : OUT  std_logic_vector(4 downto 0);
         RB : OUT  std_logic_vector(4 downto 0);
         shift : OUT  std_logic_vector(3 downto 0);
         oen : OUT  std_logic;
         s34 : OUT  std_logic_vector(1 downto 0);
         s1 : OUT  std_logic;
         IMM : OUT  std_logic_vector(15 downto 0);
         AL : OUT  std_logic_vector(3 downto 0);
         regWri : OUT  std_logic;
         Flags : IN  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instruction : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal Flags : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal address : std_logic_vector(7 downto 0);
   signal RX : std_logic_vector(4 downto 0);
   signal RA : std_logic_vector(4 downto 0);
   signal RB : std_logic_vector(4 downto 0);
   signal shift : std_logic_vector(3 downto 0);
   signal oen : std_logic;
   signal s34 : std_logic_vector(1 downto 0);
   signal s1 : std_logic;
   signal IMM : std_logic_vector(15 downto 0);
   signal AL : std_logic_vector(3 downto 0);
   signal regWri : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Controller PORT MAP (
          Instruction => Instruction,
          clk => clk,
          rst => rst,
          address => address,
          RX => RX,
          RA => RA,
          RB => RB,
          shift => shift,
          oen => oen,
          s34 => s34,
          s1 => s1,
          IMM => IMM,
          AL => AL,
          regWri => regWri,
          Flags => Flags
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
		wait for clk_period;
		rst <= '0';
		Instruction(0)<= '1';
		instruction(31 downto 26) <= "111111";
      wait;
   end process;

END;
