library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_harris is
    Port ( 
        clk               : in STD_LOGIC;
        reset             : in STD_LOGIC;
        valid_write       : in STD_LOGIC;
        data_in           : in STD_LOGIC_VECTOR(8 downto 0);
        addr_in           : in STD_LOGIC_VECTOR(17 downto 0);
        -- A continuer
    );
end top_harris;


architecture Behavioral of top_harris is
    
    signal valid_manager     : std_logic;
    signal valid_ram_mem     : std_logic;


    signal data



begin

    top_ram_inst : entity work.top_ram
        port map(
            clk => clk,
            reset => reset,
            valid_write => valid_write,
            valid_manager => valid_manager,
            addr_manager => addr_in,
            data_write => data_in(8 downto 0),
            valid_out => valid_ram_mem,
            data_out => open, -- No used
            addr_out => open -- No used
        );


end Behavioral;






