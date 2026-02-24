library IEEE; use IEEE.STD_LOGIC_1164.ALL; 

entity full_adder is 
	Port (
		x, y, cin : in std_logic; 
		cout, Sum : out std_logic ); 
end full_adder; 

architecture behav of full_adder is 
begin 
Sum <= x xor y xor cin after 5 ns;
cout <= (x and y) or ((x xor y) and cin) after 5 ns;
end behav;

