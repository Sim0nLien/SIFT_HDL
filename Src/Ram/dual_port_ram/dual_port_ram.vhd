library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_NUMERIC_STD.ALL;

-- Dans ce module, je pars du principe que la RAM est suffisamment grande pour pouvoir enregistrer l'image, bien que je sache que cela soit un choix discutable.

entity dual_port_ram is
    generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 18
    );
    port (
        clk       : in  std_logic;
        valid_write : in  std_logic;
        valid_read  : in  std_logic;
        addr_write  : in std_logic_vector(18 downto 0); -- On prend le cas ou toute l'image est enregistrée
        data_write  : in std_logic_vector(7 downto 0);
        addr_read   : out std_logic_vector(18 downto 0);
        data_read   : out std_logic_vector(7 downto 0);
    );
end entity dual_port_ram;

architecture Behavioral of dual_port_ram is

    type ram_type is array (0 to 512*512) of std_logic_vector(7 downto 0);
    signal ram : ram_type := (others => (others => '0'));

begin 
    process(clk)
    begin
        if rising_edge(clk) then        
            if valid_write = '1' then
                ram(to_integer(unsigned(addr_write))) <= data_write;
            end if;
            if valid_read = '1' then
                data_read <= ram(to_integer(unsigned(addr_read)));
            end if;
        end if;
    end process;
end Behavioral;

















