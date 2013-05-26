
-- VHDL Instantiation Created from source file reg_bank.vhd -- 10:56:17 02/27/2013
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT reg_bank
	PORT(
		Data_in : IN std_logic_vector(15 downto 0);
		RA : IN std_logic_vector(68978079 downto 0);
		RB : IN std_logic_vector(68978175 downto 0);
		WA : IN std_logic_vector(68978271 downto 0);
		W_EN : IN std_logic;
		rst : IN std_logic;
		clk : IN std_logic;          
		A : OUT std_logic_vector(15 downto 0);
		B : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_reg_bank: reg_bank PORT MAP(
		Data_in => ,
		RA => ,
		RB => ,
		WA => ,
		W_EN => ,
		rst => ,
		clk => ,
		A => ,
		B => 
	);


