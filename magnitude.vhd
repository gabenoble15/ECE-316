library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity magnitude is
  port(
    R_s         : in  signed(7 downto 0);
    Mag_u       : out unsigned(7 downto 0);
    Overflow_int: out std_logic
  );
end entity magnitude;

architecture behav of magnitude is
  signal mag_tmp : unsigned(7 downto 0);
begin

  
  mag_tmp <= unsigned(R_s) when R_s >= 0 else unsigned(-R_s);
  Mag_u   <= mag_tmp;

  -- overflow for lab range (|result| > 99)
  Overflow_int <= '1' when to_integer(mag_tmp) > 99 else '0';

end architecture behav;
