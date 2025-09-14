library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity add is
    port(
        clk      : in STD_LOGIC;
        reset    : in STD_LOGIC;
        valid_1  : in STD_LOGIC;
        valid_2  : in STD_LOGIC;
        data_1   : in STD_LOGIC_VECTOR(12 downto 0);
        data_2   : in STD_LOGIC_VECTOR(12 downto 0);
        addr_in  : in STD_LOGIC_VECTOR(17 downto 0);
        valid_out: out STD_LOGIC;
        result   : out STD_LOGIC_VECTOR(13 downto 0);
        addr_out : out STD_LOGIC_VECTOR(17 downto 0)
    );
end add;

architecture Behavioral of add is

    state_type is (init, wait, compute, output);
    state : state_type := init;

    signal flag_1   : STD_LOGIC := '0';
    signal flag_2   : STD_LOGIC := '0';

    signal data_mem_1 : signed(13 downto 0) := (others => '0');
    signal data_mem_2 : signed(13 downto 0) := (others => '0');
    signal result   : signed(13 downto 0) := (others => '0');

begin 

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= init;
                result <= (others => '0');
                addr_out <= (others => '0');
                valid_out <= '0';
                flag_1 <= '0';
                flag_2 <= '0';
            else
                case state is
                    when init =>
                        state <= wait;
                        result <= (others => '0');
                        addr_out <= (others => '0');
                        valid_out <= '0';
                        flag_1 <= '0';
                        flag_2 <= '0';

                    when wait =>
                        if valid_1 = '1' then
                            flag_1 <= '1';
                            data_mem_1 <= signed(data_1);
                        end if;
                        if valid_2 = '1' then
                            flag_2 <= '1';
                            data_mem_2 <= signed(data_2);
                        end if;
                        if flag_1 = '1' and flag_2 = '1' then
                            state <= compute;
                        end if;

                    when compute =>
                        mem_result <= data_mem_1 - data_mem_2;
                        addr_out <= addr_in;
                        valid_out <= '1';
                        state <= output;

                    when output =>
                        if valid_out = '0' then
                            state <= wait;
                        end if;
                end case;
            end if;
        end if;
    end process;
end Behavioral;









