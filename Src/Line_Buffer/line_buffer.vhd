library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity line_buffer is
    generic (
        WIDTH  : integer := 512;
        HEIGHT : integer := 512;
        DEPTH  : integer := 8
    );
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        write_enable  : in  std_logic;
        order         : in  std_logic;
        pixel_in      : in  std_logic_vector(DEPTH - 1 downto 0);
        write_address : in  std_logic_vector(31 downto 0);
        get_address   : in  std_logic_vector(31 downto 0);
        value_out     : out std_logic_vector(DEPTH - 1 downto 0);
        valid_out     : out std_logic
    );  
end line_buffer;

architecture Behavioral of line_buffer is
    type ram_type is array (0 to HEIGHT * WIDTH - 1) of std_logic_vector(DEPTH - 1 downto 0);
    signal image_ram : ram_type := (others => (others => '0'));
begin
    process(clk) 
    begin
        if rising_edge(clk) then
            if reset = '1' then
                for i in 0 to HEIGHT * WIDTH - 1 loop
                    image_ram(i) <= (others => '0');
                end loop;
                valid_out <= '0';
            else
                if write_enable = '1' then
                    image_ram(to_integer(unsigned(write_address))) <= pixel_in;
                end if;
                if order = '1' then
                    value_out <= image_ram(to_integer(unsigned(get_address)));
                    valid_out <= '1';
                else
                    valid_out <= '0';
                end if;
            end if; 
        end if;
    end process;
end Behavioral;
