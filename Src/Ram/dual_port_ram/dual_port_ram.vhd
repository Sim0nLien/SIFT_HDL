library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Dans ce module, je pars du principe que la RAM est suffisamment grande pour pouvoir enregistrer l'image, bien que je sache que cela soit un choix discutable.

entity dual_port_ram is
    generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 18
    );
    port(
        clk             : in  std_logic;
        valid_write     : in  std_logic;
        valid_read_in   : in  std_logic;
        addr_write      : in std_logic_vector(17 downto 0); -- On prend le cas ou toute l'image est enregistrée
        data_write      : in std_logic_vector(7 downto 0);
        addr_read       : in std_logic_vector(17 downto 0);
        valid_read_out  : out std_logic;
        data_read       : out std_logic_vector(7 downto 0)
    );
end entity dual_port_ram;

architecture Behavioral of dual_port_ram is

    type ram_type is array (0 to 512*5) of std_logic_vector(7 downto 0);
    signal ram : ram_type := (others => (others => '0'));
    signal val : integer := 0;
begin 
    process(clk)
    begin
        if rising_edge(clk) then        
            if valid_write = '1' then
                ram(to_integer(unsigned(addr_write))) <= data_write;
            end if;
            if valid_read_in = '1' then
                val <= to_integer(unsigned(addr_read));
                data_read <= ram(to_integer(unsigned(addr_read)));
                valid_read_out <= '1';
            else
                valid_read_out <= '0';
            end if;
        end if;
    end process;
end Behavioral;

















