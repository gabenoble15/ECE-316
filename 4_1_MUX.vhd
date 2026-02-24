library ieee;
use ieee.std_logic_1164.all;

entity mux_4to1_8bit is
    port (
        SEL : in  std_logic_vector(1 downto 0);
        D   : in  std_logic_vector(7 downto 0);

        X   : out std_logic_vector(7 downto 0));
end mux_4to1_8bit;

architecture Behavioral of mux_4to1_8bit is
begin
    with SEL select
        X <= "00000000" when "00",
             "00000001" when "01",
             "11111111" when "10",
	     D when "11",
            (others => '0') when others;
end Behavioral;

