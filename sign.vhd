library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_magnitude is
	port( 
	N : in std_logic;
	sign_display : out std_logic_vector(6 downto 0)
	);
end entity sign_magnitude;


architecture behav of sign_magnitude is 
begin 

process(N) 
begin 
if N = '1' then
	sign_display <= "0111111";
else 
	sign_display <= "1111111";
end if;
end process;
end behav; 
