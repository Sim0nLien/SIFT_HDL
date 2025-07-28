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
        valid        : in  std_logic;
        write_enable : in  std_logic;
        value_in     : in  std_logic_vector(8 downto 0);
        valid_prev   : out std_logic;
        valid_next   : out std_logic;
        address      : out std_logic_vector(31 downto 0);
        value_out    : out std_logic_vector(8 downto 0);
        count        : out std_logic_vector(4 downto 0)
    );
end adress_recup;

architecture Behavioral of adress_recup is

    signal address_current : integer := 513;  -- Adresse courante
    signal count_int : integer := 0;
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                address        <= (others => '0');
                value_out      <= (others => '0');
                valid_prev     <= '0';
                valid_next     <= '0';
                address_current <= 513;
                count_int       <= 0;

            elsif valid = '1' then
                -- Envoie de la valeur reçue
                value_out    <= value_in;
                valid_prev   <= '0';
                valid_next   <= '1';
                count      <= std_logic_vector(to_unsigned(count_int, 5));


                -- Calcul de l'adresse selon l'index
                if count_int < 3 then
                    address <= std_logic_vector(to_unsigned(address_current - 513 + count_int, 32));
                elsif count_int < 6 then
                    address <= std_logic_vector(to_unsigned(address_current + count_int - 4, 32));
                else
                    address <= std_logic_vector(to_unsigned(address_current + 511 + count_int - 6, 32));
                end if;

                count_int <= count_int + 1;

                if count_int = 9 then
                    count_int <= 0;
                    address_current <= address_current + 1;
                end if;

            else
                -- Aucune valeur reçue, on demande la suivante
                valid_prev <= '1';
                valid_next <= '0';
                value_out  <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
