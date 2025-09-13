library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mem_1x3 is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in  std_logic;
        data_in     : in  std_logic_vector(7 downto 0);
        addr_in     : in  std_logic_vector(17 downto 0);
        valid_out   : out std_logic;
        data_out_0  : out std_logic_vector(7 downto 0);
        data_out_1  : out std_logic_vector(7 downto 0);
        data_out_2  : out std_logic_vector(7 downto 0);
        addr_out    : out std_logic_vector(17 downto 0)
    );
end mem_1x3;

architecture Behavioral of mem_1x3 is

    signal data_0 : std_logic_vector(7 downto 0) := (others => '0');
    signal data_1 : std_logic_vector(7 downto 0) := (others => '0');
    signal data_2 : std_logic_vector(7 downto 0) := (others => '0');

    signal counter : integer := 0;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data_0 <= (others => '0');
                data_1 <= (others => '0');
                data_2 <= (others => '0');
                valid_out <= '0';
                counter <= 0;

            else
                if valid_in = '1' then
                    case counter is
                        when 0 =>
                            data_0 <= data_in;
                            counter <= 1;
                            valid_out <= '0';
                        when 1 =>
                            data_1 <= data_in;
                            counter <= 2;
                            valid_out <= '0';
                        when 2 =>
                            data_2 <= data_in;
                            counter <= 3;
                            valid_out <= '0';
                        when 3 =>
                            data_out_0 <= data_0;
                            data_out_1 <= data_1;
                            data_out_2 <= data_2;
                            addr_out <= addr_in;
                            valid_out <= '1';
                            counter <= 0;
                        when others =>
                            counter <= 0;
                            valid_out <= '0';
                    end case;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
