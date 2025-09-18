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

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state : state_type := INIT;

    signal flag_1   : STD_LOGIC := '0';
    signal flag_2   : STD_LOGIC := '0';

    signal data_mem_1 : signed(13 downto 0) := (others => '0');
    signal data_mem_2 : signed(13 downto 0) := (others => '0');
    signal mem_result   : signed(13 downto 0) := (others => '0');

begin 

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                result <= (others => '0');
                addr_out <= (others => '0');
                valid_out <= '0';
                flag_1 <= '0';
                flag_2 <= '0';
            else
                case state is
                    when INIT =>
               state <= WAITING;
                        mem_result <= (others => '0');
                        result <= (others => '0');
                        addr_out <= (others => '0');
                        valid_out <= '0';
                        flag_1 <= '0';
                        flag_2 <= '0';

                    when WAITING =>
                        valid_out <= '0';
                        if valid_1 = '1' then
                            flag_1 <= '1';
                            data_mem_1 <= resize(signed(data_1),14);
                        end if;
                        if valid_2 = '1' then
                            flag_2 <= '1';
                            data_mem_2 <= resize(signed(data_2),14);
                        end if;
                        if flag_1 = '1' and flag_2 = '1' then
                            state <= compute;
                        end if;

                    when COMPUTE =>
                        mem_result <= data_mem_1 - data_mem_2;
                        flag_1 <= '0';
                        flag_2 <= '0';
                        addr_out <= addr_in;
                        state <= OUTPUT;

                    when output =>
                        valid_out <= '1';
                        result <= std_logic_vector(mem_result);
                        state <= WAITING;
                        
                end case;
            end if;
        end if;
    end process;
end Behavioral;









