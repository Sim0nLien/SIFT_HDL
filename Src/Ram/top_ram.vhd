library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_ram is
    port(
        clk           : in  std_logic;
        reset         : in  std_logic;
        valid_write   : in  std_logic;
        valid_manager : in  std_logic;
        addr_manager  : in std_logic_vector(17 downto 0);
        data_write    : in  std_logic_vector(7 downto 0);
        valid_out     : out std_logic;
        data_out      : out std_logic_vector(7 downto 0);
        addr_out      : out std_logic_vector(17 downto 0)
    );
end top_ram;

architecture Behavioral of top_ram is        
    

    signal valid_write_ram : std_logic;
    signal valid_ram_read  : std_logic;
    signal valid_read_ram  : std_logic;

    signal data_write_ram : std_logic_vector(7 downto 0);
    signal data_ram_read  : std_logic_vector(7 downto 0);

    signal addr_write_ram : std_logic_vector(17 downto 0);
    signal addr_ram_read  : std_logic_vector(17 downto 0);
    signal addr_read_ram  : std_logic_vector(17 downto 0);

begin

    write_image_inst : entity work.write_image
        port map(
               clk => clk,
               reset => reset,
               valid_in => valid_write,
               data_in => data_write,
               valid_out => valid_ram_read,
               data_out => data_write_ram,
               addr_out => addr_write_ram
        );

    dual_port_ram_inst : entity work.dual_port_ram
        generic map(
                DATA_WIDTH => 8,
                ADDR_WIDTH => 18
        )
        port map(
                clk => clk,
                valid_write => valid_write_ram,
                valid_read => valid_read_ram,
                addr_write => addr_write_ram,
                data_write => data_write_ram,
                addr_read => addr_ram_read,
                data_read => data_ram_read
        );

    read_image_inst : entity work.read_image
        port map(
                clk => clk,
                reset => reset,
                valid_ram_in => valid_ram_read,
                valid_manager_in => valid_manager,
                data_in => data_ram_read,
                addr_manager => addr_manager,
                valid_ram_out => valid_ram_read,
                valid_mem_out => valid_out,
                addr_order => addr_read_ram,
                addr_out => addr_out,
                data_out => data_out
        );

end Behavioral;




