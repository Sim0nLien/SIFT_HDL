library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adress_recup is
    generic (
        WIDTH  : integer := 512;
        HEIGHT : integer := 512
    );
    port(
        clk          : in  std_logic;
        reset        : in  std_logic;
        order        : in  std_logic;
        next_order   : out std_logic;        
        address      : out std_logic_vector(31 downto 0)
    );
end adress_recup;

architecture Behavioral of adress_recup is

    signal address_current : integer := 513;  -- Adresse courante
    signal count_int : integer := 0;

begin

    process(clk)
        variable next_addr : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                address         <= (others => '0');
                address_current <= 512;
                count_int       <= 0;
                next_order      <= '0';

            elsif order = '1' then
                if count_int = 0 then
                    address <= std_logic_vector(to_unsigned(address_current - 512, 32));
                    count_int <= 1;
                    next_order <= '1';

                elsif count_int = 1 then
                    address <= std_logic_vector(to_unsigned(address_current, 32));
                    count_int <= 2;
                    next_order <= '1';

                elsif count_int = 2 then
                    address <= std_logic_vector(to_unsigned(address_current + 512, 32));
                    count_int <= 0;
                    next_order <= '1';
                    next_addr := address_current + 1;


                    if next_addr > WIDTH * (HEIGHT - 2) then
                        address_current <= 512;
                    else
                        address_current <= next_addr;
                    end if;
                end if;

            else
                next_order <= '0';
            end if;
        end if;
    end process;

end Behavioral;