--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:50:03 05/09/2013
-- Design Name:   
-- Module Name:   C:/Users/rjm529/CA/Controller/ALUContTest.vhd
-- Project Name:  Controller
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALUController
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
 
ENTITY ALUContTest IS
END ALUContTest;
 
ARCHITECTURE behavior OF ALUContTest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALUController
    PORT(
         Opcode : IN  std_logic_vector(5 downto 0);
         alu_sig : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Opcode : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal alu_sig : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALUController PORT MAP (
          Opcode => Opcode,
          alu_sig => alu_sig
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		Opcode <= "000000";
		wait for 10 ns;
		Opcode <= "000011";
		wait for 10 ns;
		
      wait;
   end process;

END;
