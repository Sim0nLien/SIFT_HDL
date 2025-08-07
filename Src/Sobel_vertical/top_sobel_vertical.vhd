-- top Sobel Vertical

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_sobel_vertical is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in  std_logic;
        pixel_in    : in  std_logic_vector(7 downto 0);
        next_order  : out std_logic;
        address     : out std_logic_vector(31 downto 0);
        valid_out   : out std_logic;
        result_out  : out std_logic_vector(13 downto 0)
    );
end top_sobel_vertical;

architecture Behavioral of top_sobel_vertical is

    signal valid_back  : std_logic;
    
begin 

    adress_recup : entity work.adress_recup
        port map (
            clk          => clk,
            reset        => reset,
            order        => valid_back,
            next_order   => next_order,
            address      => address
        );


    conv_sobel : entity work.conv_sobel
        port map(
            clk         => clk,
            reset       => reset,
            valid_in    => valid_in,
            pixel_in    => pixel_in,
            valid_back  => valid_back,
            valid_out   => valid_out,
            result_out  => result_out
        );

end Behavioral;

