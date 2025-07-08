library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity adress_recup is
    generic (
        WIDTH : integer := 512;
        HEIGHT : integer := 512;
    };

    port(
        clk : in std_logic;
        reset : in std_logic;
        valid : in std_logic; -- Valid du bloc précèdent
        write_enable : in std_logic; -- Valid du bloc suivant
        value_in : in std_logic_vector(8 downto 0); -- Valeur d'entrée
        valid_in : out std_logic; -- Pour le bloc précèdent
        valid_out : out std_logic -- Pour le bloc suivant
        address : out std_logic_vector(31 downto 0);
        value_out : out std_logic_vector(8 downto 0); -- Valeurs de sortie
    )

end adress_recup;

architecture Behavioral of adress_recup is

begin -- Architecture
process(clk)
    if rising_edge(clk) then
        if reset = '1' then
            address <= (others => '0');
            value <= (others => '0');
            valid_in <= '0';
            valid_out <= '0';
        if valid = '1' then
            value 