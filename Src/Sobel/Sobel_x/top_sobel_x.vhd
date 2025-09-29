library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_sobel_x is 
    port(
        clk               : in STD_LOGIC;
        reset             : in STD_LOGIC;
        valid_data_1_in   : in STD_LOGIC;
        valid_data_2_in   : in STD_LOGIC;
        data_1_in         : in STD_LOGIC_VECTOR(7 downto 0);
        data_2_in         : in STD_LOGIC_VECTOR(7 downto 0);
        addr_in           : in STD_LOGIC_VECTOR(17 downto 0);
        valid_out         : out STD_LOGIC;
        data_out          : out STD_LOGIC_VECTOR(13 downto 0);
        addr_out          : out STD_LOGIC_VECTOR(17 downto 0)    
    );
    end top_sobel_x;

architecture Behavioral of top_sobel_x is
    
    signal valid_out_row_0 : STD_LOGIC;
    signal valid_out_row_2 : STD_LOGIC;
    
    signal data_out_row_0  : STD_LOGIC_VECTOR(12 downto 0);
    signal data_out_row_2  : STD_LOGIC_VECTOR(12 downto 0);

    signal addr_out_row_0  : STD_LOGIC_VECTOR(17 downto 0);

begin

    row_0_inst : entity work.row_0
        port map(
            clk => clk,
            reset => reset,
            addr_in => addr_in,
            data_in => data_1_in,
            valid_in => valid_data_1_in,
            valid_out => valid_out_row_0,
            addr_out => addr_out_row_0,
            data_out => data_out_row_0
        );
    
    row_2_inst : entity work.row_0
       port map(
           clk => clk,
           reset => reset,
           addr_in => addr_in,
           data_in => data_2_in,
           valid_in => valid_data_2_in,
           valid_out => valid_out_row_2,
           addr_out => open, -- No used
           data_out => data_out_row_2
       );

    add_inst : entity work.add
        port map(
            clk => clk,
            reset => reset,
            valid_1 => valid_out_row_0,
            valid_2 => valid_out_row_2,
            data_1 => data_out_row_0,
            data_2 => data_out_row_2,
            addr_in => addr_out_row_0,
            valid_out => valid_out,
            result => data_out,
            addr_out => addr_out
        );

end Behavioral;
