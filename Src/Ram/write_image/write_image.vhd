library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity write_image is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in std_logic;
        data_in     : in std_logic_vector(8 downto 0);
        valid_out   : out std_logic;
        data_out    : out std_logic_vector(18 downto 0)
        addrs_out   : out std_logic_vector(18 downto 0)
    );
end write_image;


architecture Behavioral of write_image is
    type state_type is (INIT, WAITING, OUTPUT);
    signal state : state_type := INIT;

    signal addr_pix : unsigned(17 downto 0) := (others => '0');
    signal data_pix : unsigned(7 downto 0) := (others => '0');


begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                addr_pix <= (others => '0');
                data_pix <= (others => '0');
                valid_out <= '0';
                data_out <= (others => '0');

            else

            case
             state is
                when INIT =>
                    addr_pix <= (others => '0');
                    data_pix <= (others => '0');
                    valid_out <= '0';
                    data_out <= (others => '0');
                    state <= WAITING;

                when WAITING =>
                    valid_out <= '0';
                    if valid_in = '1' then
                        data_pix <= unsigned(data_in);
                        state <= OUTPUT;
                        addr_pix <= addr_pix + 1;
                    end if;

                when OUTPUT =>
                    valid_out <= '1';
                    data_out <= std_logic_vector(data_pix);
                    addrs_out <= std_logic_vector(addr_pix);
                    state <= WAITING;
                    if addr_pix = to_unsigned(512*512, 19) then
                        state <= INIT;
                    end if;
                end case
            end if;
        end if;
    end process;
end Behavioral;







