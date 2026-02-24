library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port(
        Din       : in  std_logic_vector(7 downto 0);
        Op        : in  std_logic_vector(1 downto 0);
        Clk       : in  std_logic;
        Load_X    : in  std_logic;
        Load_Y    : in  std_logic;

        -- hardware outputs (add these so you can pin-assign them)
        Seg_Ones  : out std_logic_vector(6 downto 0);
        Seg_Tens  : out std_logic_vector(6 downto 0);
        Sum       : out std_logic_vector(7 downto 0);
        Overflow  : out std_logic
    );
end entity adder;

architecture struct of adder is

    component Register8 is
        port(
            Inp  : in  std_logic_vector(7 downto 0);
            Load : in  std_logic;
            Clk  : in  std_logic;
            Outp : out std_logic_vector(7 downto 0)
        );
    end component;

    component mux_4to1_8bit is
        port(
            SEL : in  std_logic_vector(1 downto 0);
            D   : in  std_logic_vector(7 downto 0);
            X   : out std_logic_vector(7 downto 0)
        );
    end component;

    component Adder8 is
        port(
            A, B : in  std_logic_vector(7 downto 0);
            Cin  : in  std_logic;
            Cout : out std_logic;
            S    : out std_logic_vector(7 downto 0)
        );
    end component;

    component BCDconverter is
        port(
            Din : in  std_logic_vector(7 downto 0);
            Do1 : out std_logic_vector(3 downto 0);
            Do2 : out std_logic_vector(3 downto 0)
        );
    end component;

    component display_circuit is
        port(
            BCD      : in  std_logic_vector(3 downto 0);
            Segments : out std_logic_vector(6 downto 0)
        );
    end component;

    signal L_X      : std_logic_vector(7 downto 0);
    signal L_Y      : std_logic_vector(7 downto 0);
    signal Y_A      : std_logic_vector(7 downto 0);
    signal Sum_int  : std_logic_vector(7 downto 0);
    signal Ovf_int  : std_logic;

    signal D0out    : std_logic_vector(3 downto 0);  -- ones
    signal D1out    : std_logic_vector(3 downto 0);  -- tens
    signal ones_int : std_logic_vector(6 downto 0);
    signal tens_int : std_logic_vector(6 downto 0);

begin

    -- Load Din into X register when Load_X = 1
    LoadX : Register8
        port map(
            Inp  => Din,
            Load => Load_X,
            Clk  => Clk,
            Outp => L_X
        );

    -- Load Din into Y register when Load_Y = 1
    LoadY : Register8
        port map(
            Inp  => Din,
            Load => Load_Y,
            Clk  => Clk,
            Outp => L_Y
        );

    -- Select what goes into adder B input
    MUX : mux_4to1_8bit
        port map(
            SEL => Op,
            D   => L_Y,
            X   => Y_A
        );

    -- Add X + selected(Y-path)
    Add : Adder8
        port map(
            A    => L_X,
            B    => Y_A,
            Cin  => '0',
            Cout => Ovf_int,
            S    => Sum_int
        );

    -- Binary to BCD
    BCD : BCDconverter
        port map(
            Din => Sum_int,
            Do1 => D0out,
            Do2 => D1out
        );

    -- 7-seg decode
    Display_Tens : display_circuit
        port map(
            BCD      => D1out,
            Segments => tens_int
        );

    Display_Ones : display_circuit
        port map(
            BCD      => D0out,
            Segments => ones_int
        );

    -- drive top-level outputs for pin assignment
	Seg_Ones <= ones_int;
	Seg_Tens <= tens_int;
	Sum      <= Sum_int;

process(Sum_int)
begin
    if unsigned(Sum_int) > 99 then
        Overflow <= '1';
    else
        Overflow <= '0';
    end if;
end process;

end architecture struct;
