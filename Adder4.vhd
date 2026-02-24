library IEEE; use IEEE.STD_LOGIC_1164.ALL; 
Entity Adder4 is
    port (
        A, B : in bit_vector(3 downto 0);
        Cin : in bit;
	Cout : out bit;
        S : out bit_vector(3 downto 0)
);
   
   
End Adder4;

Architecture struct of Adder4 is

    Component full_adder
        port (
            X, Y, Cin : in bit;
            Cout, Sum : out bit
        );
    End component;

    Signal C : bit_vector(3 downto 1);

Begin
    	FA0 : full_adder port map(A(0), B(0), Cin, C(1), S(0));
	FA1 : full_adder port map(A(1), B(1), C(1), C(2), S(1));
	FA2 : full_adder port map(A(2), B(2), C(2), C(3), S(2)); 
	FA3 : full_adder port map(A(3), B(3), C(3), Cout, S(3));   
    
 
    End struct;

