
library IEEE; use IEEE.STD_LOGIC_1164.ALL; 
Entity Adder8 is
    port (
        A, B : in std_logic_vector(7 downto 0);
        Cin : in std_logic;
	Cout : out std_logic;
        S : out std_logic_vector(7 downto 0)
);
   
   
End Adder8;

Architecture struct of Adder8 is

    Component full_adder
        port (
            X, Y, Cin : in std_logic;
            Cout, Sum : out std_logic
        );
    End component;

    Signal C : std_logic_vector(7 downto 1);

Begin
    	FA0 : full_adder port map(A(0), B(0), Cin, C(1), S(0));
	FA1 : full_adder port map(A(1), B(1), C(1), C(2), S(1));
	FA2 : full_adder port map(A(2), B(2), C(2), C(3), S(2)); 
	FA3 : full_adder port map(A(3), B(3), C(3), C(4), S(3)); 
	FA4 : full_adder port map(A(4), B(4), C(4), C(5), S(4));
	FA5 : full_adder port map(A(5), B(5), C(5), C(6), S(5));
	FA6 : full_adder port map(A(6), B(6), C(6), C(7), S(6));
	FA7 : full_adder port map(A(7), B(7), C(7), Cout, S(7));
	  
    
 
    End struct;

