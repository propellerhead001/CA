----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:39:10 04/22/2013 
-- Design Name: 
-- Module Name:    MemMan - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemMan is
    Port ( ledSig : out  STD_LOGIC_VECTOR (15 downto 0);
			  clk : in  STD_LOGIC;
			  rst : IN STD_LOGIC;
           buttonIn : in  STD_LOGIC;
			  CUInstrOut : out STD_LOGIC_VECTOR (31 downto 0);
			  CUInstrAddr : in STD_LOGIC_VECTOR (7 downto 0);
			  OEn : in STD_LOGIC;
			  PUDataIn : in STD_LOGIC_VECTOR (15 downto 0);
			  PUDataOut : out STD_LOGIC_VECTOR (15 downto 0);
			  PUAddr : in STD_LOGIC_VECTOR (8 downto 0));
end MemMan;

architecture Behavioral of MemMan is
COMPONENT DPMem
  PORT (
    a : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    dpo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
	signal memInstrIn, memDataIn : STD_LOGIC_VECTOR (31 downto 0);
	signal memDataOut : STD_LOGIC_VECTOR (31 downto 0);
	signal memInstrAddr, memDataAddr : STD_LOGIC_VECTOR (6 downto 0);
	signal memWE, ledEn : STD_LOGIC;
begin
memUnit: DPMem
  PORT MAP (
    a => memInstrAddr,
    d => memDataOut,
    dpra => memDataAddr,
    clk => clk,
    we => memWE,
    spo => memInstrIn,
    dpo => memDataIn
  );
  CUInstrOut <= memInstrIn;
  --Enable Memory Write
  memWE <= '0' when (PUAddr = "111111111") else
			  '0' when (PUAddr = "111111110") else
			  oen;
  memDataAddr <= PUAddr(8 downto 2);
  memInstrAddr <= CUInstrAddr(6 downto 0);
  --allow both halves of the 32-bit word to be used and button to output
  PUDataOut <= (others => '1') when (PUAddr = "111111111") else
					memDataIn(15 downto 0) when PUAddr(1) = '0' else
					memDataIn(31 downto 16);
  memDataOut(31 downto 16) <= memDataIn(31 downto 16) when PUAddr(1) = '0' else
									PUDataIn;
  memDataOut(15 downto 0) <= memDataIn(15 downto 0) when PUAddr(1) = '1' else
									PUDataIn;
  --Enable LED
  ledEn <= '1' when ((PUAddr = "111111111") and (oen = '1')) else
			  '0';

	

	led: process (clk)
	begin
		if(rising_edge(clk))then
			if(rst = '1') then
				ledSig <= (others => '0');
			elsif (ledEn = '1') then
				ledSig <= PUDataIn;
			end if;
		end if;
	end process led;
end Behavioral;

