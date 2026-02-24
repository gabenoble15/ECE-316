
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCDconverter is
    port (
        Din   : in  std_logic_vector(7 downto 0);

        Do1   : out std_logic_vector(3 downto 0);
	Do2   : out std_logic_vector(3 downto 0)
);
end BCDconverter ;

architecture struct of BCDconverter is

	Component add3
        port(
        	din  : in  std_logic_vector(3 downto 0);
        	dout : out std_logic_vector(3 downto 0)
	);
    	End component;
	
	signal out1, out2, out3, out4, out5, out6, out7 : std_logic_vector(3 downto 0);
	signal t : std_logic_vector(3 downto 0);
    	signal u : std_logic_vector(3 downto 0);
begin
        U1 : add3 port map(din(3) => '0', din(2) => Din(7), din(1) => Din(6), din(0) => Din(5), dout => out1);
	U2 : add3 port map(din(3) => out1(2), din(2) => out1(1), din(1) => out1(0), din(0) => Din(4), dout => out2);
	U3 : add3 port map(din(3) => out2(2), din(2) => out2(1), din(1) => out2(0), din(0) => Din(3), dout => out3);
	U4 : add3 port map(din(3) => out3(2), din(2) => out3(1), din(1) => out3(0), din(0) => Din(2), dout => out4);
	U5 : add3 port map(din(3) => '0', din(2) => out1(3), din(1) => out2(3), din(0) => out3(3), dout => out5);
   	U6 : add3 port map(din(3) => out4(2), din(2) => out4(1), din(1) => out4(0), din(0) => Din(1), dout => out6);
    	U7 : add3 port map(din(3) => out5(2), din(2) => out5(1), din(1) => out5(0), din(0) => out4(3), dout => out7);

    	t <= out7(2 downto 0) & out6(3);
    	u <= out6(2 downto 0) & Din(0);

	process(Din, t, u)
    	begin
        	if unsigned(Din) > 99 then
            		Do1 <= "XXXX";
            		Do2 <= "XXXX";
        	else
            		Do1 <= u;
            		Do2 <= t;
        	end if;
    	end process;
end struct;
