library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_sobel is
    Port ( 
        clk               : in STD_LOGIC;
        reset             : in STD_LOGIC;
        valid_data_1_in   : in STD_LOGIC;
        valid_data_2_in   : in STD_LOGIC;
        valid_data_3_in   : in STD_LOGIC;
        data_1_in         : in STD_LOGIC_VECTOR(7 downto 0);
        data_2_in         : in STD_LOGIC_VECTOR(7 downto 0);
        data_3_in         : in STD_LOGIC_VECTOR(7 downto 0);
        addr_in           : in STD_LOGIC_VECTOR(17 downto 0);
        valid_out_x       : out STD_LOGIC;
        valid_out_y       : out STD_LOGIC;
        data_out          : out STD_LOGIC_VECTOR(13 downto 0);
        addr_out          : out STD_LOGIC_VECTOR(17 downto 0);
        data_out_x        : out STD_LOGIC_VECTOR(13 downto 0);
        data_out_y        : out STD_LOGIC_VECTOR(13 downto 0)
    );
end top_sobel;



architecture Behavioral of top_sobel is
begin

    sobel_x_inst : entity work.top_sobel_x
        port map(
            clk => clk,
            reset => reset,
            valid_data_1_in => valid_data_1_in,
            valid_data_2_in => valid_data_3_in,
            data_1_in => data_1_in,
            data_2_in => data_3_in,
            addr_in => addr_in,
            valid_out => valid_out_x,
            data_out => data_out_x,
            addr_out => addr_out
        );

    sobel_y_inst : entity work.top_sobel_y
        port map(
            clk => clk,
            reset => reset,
            valid_in_1 => valid_data_1_in,
            valid_in_2 => valid_data_2_in,
            valid_in_3 => valid_data_3_in,
            data_in_1 => data_1_in,
            data_in_2 => data_2_in,
            data_in_3 => data_3_in,
            addr_in => addr_in,
            valid_out => valid_out_y,
            data_out => data_out_y,
            addr_out => open
        );

end Behavioral;









