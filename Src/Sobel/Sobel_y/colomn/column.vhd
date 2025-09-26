library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Ici le bloc va fonctionner avec un moins en mode plus puis moins afin de travailler avec 2 temps puis le bloc final on est sur 3 temps

entity column is
    Port ( clk          : in STD_LOGIC;
           reset        : in STD_LOGIC;
           valid_in     : in STD_LOGIC;
           data_in      : in STD_LOGIC_VECTOR (7 downto 0);
           addr_in      : in STD_LOGIC_VECTOR (17 downto 0);
           valid_out    : out STD_LOGIC;
           data_out     : out STD_LOGIC_VECTOR (12 downto 0);
           addr_out     : out STD_LOGIC_VECTOR (17 downto 0)
           );
end column;

architecture Behavioral of column is

    type state_type is (init, state_1, state_2, state_3, compute, output);
    signal state     : state_type := init;

    signal data_1    : signed(12 downto 0);
    signal data_3    : signed(12 downto 0);
    
    signal result    : signed(12 downto 0);
    
    signal flag      : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= init;
                data_1 <= (others => '0');
                data_3 <= (others => '0');
                addr_out <= (others => '0');
                data_out <= (others => '0');
                valid_out <= '0';
           
            else
            
                case state is
                    when init =>
                        state <= state_1;
                        data_1 <= (others => '0');
                        data_3 <= (others => '0');
                        addr_out <= (others => '0');
                        
                    when state_1 =>
                        valid_out <= '0';
                        if valid_in = '1' then
                            data_1 <= resize(signed(data_in), 13);
                            state <= state_2;
                        end if;
                        
                    when state_2 =>
                        if valid_in = '1' then
                            state <= state_3;
                        end if;
                    
                    when state_3 =>
                        if valid_in = '1' then
                            data_3 <= resize(signed(data_in), 13);
                            state <= compute;
                        end if;

                    when compute =>
                        result <= data_1 - data_3;
                        state <= output;

                    when output =>
                        valid_out <= '1';
                        data_out <= std_logic_vector(result);
                        addr_out <= addr_in;
                        state <= init;

                end case;
            end if;
        end if;
    end process;

end Behavioral;