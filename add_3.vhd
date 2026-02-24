library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity add3 is
    port(
        din  : in  std_logic_vector(3 downto 0);
        dout : out std_logic_vector(3 downto 0)
    );
end add3;

architecture Behavioral of add3 is
begin

    process(din) 
        variable temp : unsigned(3 downto 0);
    begin
        temp := unsigned(din);

        if temp >= 5 then
            temp := temp + 3;
        end if;
        dout <= std_logic_vector(temp);
    end process;
end Behavioral;

