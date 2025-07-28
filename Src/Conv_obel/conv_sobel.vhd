library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity conv_sobel is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        valid_in  : in  std_logic;
        pixel_in  : in  std_logic_vector(7 downto 0);
        valid_out : out std_logic;
        result_out : out std_logic_vector(7 downto 0) -- Check
    );
end conv_sobel;

architecture Behavioral of conv_sobel is

    signal buffer : std_logic_vector(10 downto 0) := (others => '0');

    type sobel_matrix_type is array (0 to 2, 0 to 2) of integer;
    constant matrice_sobel : sobel_matrix_type := (
        ( 1,  0, -1),
        ( 2,  0, -2),
        ( 1,  0, -1)
    );
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                