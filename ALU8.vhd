library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ALU8 is
  port(
    X, Y     : in  std_logic_vector(7 downto 0);
    Opr      : in  std_logic_vector(2 downto 0);
    Result   : out std_logic_vector(7 downto 0);
    O    : out std_logic;  
    Negative : out std_logic
  );
end ALU8;

architecture struct of ALU8 is
	component Adder8
    		port(
      		A, B : in  std_logic_vector(7 downto 0);
      		Cin  : in  std_logic;
      		Cout : out std_logic;
      		S    : out std_logic_vector(7 downto 0)
    		);
  	end component;

  	signal A_sel, B_sel : std_logic_vector(7 downto 0);
  	signal Cin_sel      : std_logic;
  	signal Result_int   : std_logic_vector(7 downto 0);
  	signal overflow     : std_logic;
	signal Cout_int     : std_logic;
	
	component magnitude
		port(
    		R_s         : in  signed(7 downto 0);
   	 	Mag_u       : out unsigned(7 downto 0);
    		Overflow_int: out std_logic
  		);
	end component;
	signal final_result : unsigned(7 downto 0);
	
	

	

begin

	with Opr select
    		A_sel <= X        when "000",  -- X
             	X        when "001",  -- X+1
             	X        when "010",  -- X-1
             	not X    when "011",  -- -X
             	not Y    when "100",  -- -Y
             	X        when "101",  -- X+Y
             	X        when "110",  -- X-Y
             	Y        when "111",  -- Y-X
             	(others => '0') when others;

  	with Opr select
    		B_sel <= (others => '0') when "000", -- X
             	(others => '0') when "001", -- X+1
             	(others => '1') when "010", -- X-1
             	(others => '0') when "011", -- -X
             	(others => '0') when "100", -- -Y
             	Y               when "101", -- X+Y
             	not Y           when "110", -- X-Y
             	not X           when "111", -- Y-X
             	(others => '0') when others;

  	with Opr select
    		Cin_sel <= '0' when "000",
               	'1' when "001",
               	'0' when "010",
               	'1' when "011",
               	'1' when "100",
               	'0' when "101",
               	'1' when "110",
               	'1' when "111",
               	'0' when others;

  	U1: Adder8
    		port map(
      		A    => A_sel,
      		B    => B_sel,
      		Cin  => Cin_sel,
      		Cout => Cout_int,
      		S    => Result_int
    		);
	

	Negative <= Result_int(7);
  
	
  	Convert: magnitude
  		port map(
    		R_s          => signed(Result_int),
    		Mag_u        => final_result,
    		Overflow_int => overflow
  		);
	O <= overflow;
	Result <= std_logic_vector(final_result);

	
end struct;



