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
    component magnitude is
        port(
            R_s          : in  signed(8 downto 0);      
            Mag_u        : out unsigned(7 downto 0);
            Overflow_int : out std_logic
        );
    end component;

    signal Res9         : signed(8 downto 0);          
    signal final_result : unsigned(7 downto 0);
    signal overflow     : std_logic;

begin

    -- Compute the TRUE signed result in 9 bits (prevents wrap)
    process(X, Y, Opr)
        variable xs, ys : signed(8 downto 0);
    begin
        xs := resize(signed(X), 9);
        ys := resize(signed(Y), 9);

        case Opr is
            when "000" => Res9 <= xs;         -- X
            when "001" => Res9 <= xs + 1;     -- X+1
            when "010" => Res9 <= xs - 1;     -- X-1
            when "011" => Res9 <= -xs;        -- -X
            when "100" => Res9 <= -ys;        -- -Y
            when "101" => Res9 <= xs + ys;    -- X+Y
            when "110" => Res9 <= xs - ys;    -- X-Y
            when "111" => Res9 <= ys - xs;    -- Y-X
            when others => Res9 <= (others => '0');
        end case;
    end process;

    -- Negative from the TRUE result
    Negative <= Res9(8);

    -- Magnitude + overflow computed from TRUE result
    Convert: magnitude
        port map(
            R_s          => Res9,
            Mag_u        => final_result,
            Overflow_int => overflow
        );

    O      <= overflow;
    Result <= std_logic_vector(final_result);

end struct;



