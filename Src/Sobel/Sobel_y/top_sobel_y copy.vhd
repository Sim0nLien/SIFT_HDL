library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_sobel_y is
    port (
        clk               : in STD_LOGIC;
        reset             : in STD_LOGIC;
        valid_in_1        : in STD_LOGIC;
        valid_in_2        : in STD_LOGIC;
        valid_in_3        : in STD_LOGIC;
        data_in_1         : in STD_LOGIC_VECTOR (7 downto 0);
        data_in_2         : in STD_LOGIC_VECTOR (7 downto 0);
        data_in_3         : in STD_LOGIC_VECTOR (7 downto 0);
        valid_out         : out STD_LOGIC;
        data_out          : out STD_LOGIC_VECTOR (12 downto 0);
        addr_out          : out STD_LOGIC_VECTOR (17 downto 0)
    );
end top_sobel_y;


architecture Behavioral of top_sobel_y is

    signal valid_row_1   : STD_LOGIC;
    signal valid_row_2   : STD_LOGIC;
    signal valid_row_3   : STD_LOGIC;

    signal data_row_1    : STD_LOGIC_VECTOR (12 downto 0);
    signal data_row_2    : STD_LOGIC_VECTOR (12 downto 0);
    signal data_row_3    : STD_LOGIC_VECTOR (12 downto 0);

    signal addr_row_1    : STD_LOGIC_VECTOR (17 downto 0);
    
begin

    row_1_inst : entity work.row
        port map(
            clk       => clk,
            reset     => reset,
            valid_in  => valid_in_1,
            data_in   => data_in_1,
            addr_in   => addr_in,
            valid_out => valid_row_1,
            data_out  => data_row_1,
            addr_out  => addr_row_1
        );

    row_2_inst : entity work.row
        port map(
            clk       => clk,
            reset     => reset,
            valid_in  => valid_in_2,
            data_in   => data_in_2,
            addr_in   => open,
            valid_out => valid_row_2,
            data_out  => data_row_2,
            addr_out  => open
        );

    row_3_inst : entity work.row
        port map(
            clk       => clk,
            reset     => reset,
            valid_in  => valid_in_3,
            data_in   => data_in_3,
            addr_in   => open,
            valid_out => valid_row_3,
            data_out  => data_row_3,
            addr_out  => open
        );

    add_y_inst : entity work.add_y
        port map(
            clk        => clk,
            reset      => reset,
            valid_in_1 => valid_row_1,
            valid_in_2 => valid_row_2,
            valid_in_3 => valid_row_3,
            data_in_1  => data_row_1,
            data_in_2  => data_row_2,
            data_in_3  => data_row_3,
            addr_in    => addr_row_1,
            valid_out  => valid_out,
            data_out   => data_out,
            addr_out   => addr_out
        );
        
end Behavioral;




