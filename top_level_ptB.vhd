library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_ptB is
    port(
        Din       : in  std_logic_vector(7 downto 0);
        Op        : in  std_logic_vector(2 downto 0);
        Clk       : in  std_logic;
        Load_X    : in  std_logic;
        Load_Y    : in  std_logic;

        -- hardware outputs (add these so you can pin-assign them)
        Seg_Ones  : out std_logic_vector(6 downto 0);
        Seg_Tens  : out std_logic_vector(6 downto 0);
	Seg_sign : out std_logic_vector(6 downto 0); 
        Overflow  : out std_logic
    );
end entity top_level_ptB;
 


architecture struct of top_level_ptB is

	component Register8 is
        	port(
            	Inp  : in  std_logic_vector(7 downto 0);
            	Load : in  std_logic;
            	Clk  : in  std_logic;
            	Outp : out std_logic_vector(7 downto 0)
        	);
    	end component;

	component ALU8 is
  		port(
    		X, Y     : in  std_logic_vector(7 downto 0);
    		Opr      : in  std_logic_vector(2 downto 0);
    		Result   : out std_logic_vector(7 downto 0);
    		O    : out std_logic;  
    		Negative : out std_logic
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

	component sign_magnitude is
	port( 
	N : in std_logic;
	sign_display : out std_logic_vector(6 downto 0)
	);
	end component sign_magnitude;


	


	signal L_X      : std_logic_vector(7 downto 0);
	signal L_Y      : std_logic_vector(7 downto 0);
	signal store_result : std_logic_vector(7 downto 0);
	signal store_overflow : std_logic;
	signal store_negative : std_logic;
	signal D0out    : std_logic_vector(3 downto 0);  -- ones
    	signal D1out    : std_logic_vector(3 downto 0);  -- tens
	signal ones_int : std_logic_vector(6 downto 0);
    	signal tens_int : std_logic_vector(6 downto 0);






begin
	LoadX : Register8
        port map(
            Inp  => Din,
            Load => Load_X,
            Clk  => Clk,
            Outp => L_X
        );


    	LoadY : Register8
        port map(
            	Inp  => Din,
           	Load => Load_Y,
            	Clk  => Clk,
            	Outp => L_Y
        );

 	Do_Math: ALU8
        port map(
        	X    => L_X,
            	Y    => L_Y,
            	Opr  => Op,
            	Result => store_result,
            	O    => store_overflow,
		Negative => store_negative
	
        );
	  
	BCD : BCDconverter
        port map(
            Din => store_result,
            Do1 => D0out,
            Do2 => D1out
        );
	
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
	
	Display_sign : sign_magnitude
	port map(
		N => store_negative,
		sign_display => Seg_sign
	); 

	
	
	--Seg_Ones <= ones_int;
    	--Seg_Tens <= tens_int;
    	--Overflow <= store_overflow;

	
	process(store_result, D0out, D1out)
	begin
    		if unsigned(store_result) > 99 then
        
       
        	Seg_Ones <= "XXXXXXX";
        	Seg_Tens <= "XXXXXXX";
        	Overflow <= '1';

    		else
        
        
        	Seg_Ones <= ones_int;
        	Seg_Tens <= tens_int;
        	Overflow <= '0';

    		end if;
	end process;



end architecture struct;

