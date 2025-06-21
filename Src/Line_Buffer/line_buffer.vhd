library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity line_buffer is
    generic (
        WIDTH : integer := 512;
        HEIGHT : integer := 512;
        DEPTH : integer := 8
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        pixel_in : in std_logic_vector(DEPTH - 1 downto 0);
        write_enable : in std_logic;
        write_address : in integer range 0 to HEIGHT * WIDTH - 1
    );  
end line_buffer;


architecture Behavioral of line_buffer is
    type ram_type is array (0 to HEIGHT * WIDTH - 1) of std_logic_vector(DEPTH - 1 downto 0);
    signal image_ram : ram_type := (others => (others => '0'));
begin --Architecture
    process(clk) 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                for i in 0 to HEIGHT * WIDTH - 1 loop
                    image_ram(i) <= (others => '0');
                end loop;
            elsif write_enable = '1' then
                    image_ram(write_address)<= pixel_in;
            end if; 
        end if;
    end process;
end Behavioral;

