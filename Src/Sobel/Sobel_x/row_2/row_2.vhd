library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity sobel_x is
    port(
        clk         : in STD_LOGIC;
        reset       : in STD_LOGIC;
        addr_in     : in STD_LOGIC_VECTOR(17 downto 0); 
        data_in     : in STD_LOGIC_VECTOR(7 downto 0);
        valid_in    : in STD_LOGIC;
        valid_out   : out STD_LOGIC
        addr_out    : out STD_LOGIC_VECTOR(17 downto 0);
        data_out    : out STD_LOGIC_VECTOR(12 downto 0);
    );
end sobel_x;


architecture Behavioral of sobel_x is

    type state_type is (init, state_1, state_2, state_3, compute, output);
    signal state     : state_type := init;

    signal data_1    : unsigned(7 downto 0);
    signal data_2    : unsigned(7 downto 0);
    
    signal result    : unsigned(12 downto 0);
    
    signal flag      : STD_LOGIC := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= init;
                data_1 <= (others => '0');
                data_2 <= (others => '0');
                addr_out <= (others => '0');
                data_out <= (others => '0');
                valid_out <= '0';
           
            else
            
                case state is
                    when init =>
                        state <= state_1;
                        data_1 <= (others => '0');
                        data_2 <= (others => '0');
                        addr_out <= (others => '0');
                        
                    when state_1 =>
                        if valid_in = '1' then
                            data_1 <= resize((unsigned(data_in), 13);
                            state <= state_2;
                            flag <= '1';
                        end if;

                    when state_2 =>
                        if flag = '1' then
                            result <= data_1;
                            flag <= '0';
                        elsif valid_in = '1' then
                            data_2 <= resize(unsigned(data_in), 13);
                            state <= state_3;
                            flag <= '1';
                        end if;

                    when state_3 =>
                        if flag = '1' then
                            result <= result + data_2 * 2;
                            flag <= '0';
                        elsif valid_in = '1' then
                            data_3 <= resize(unsigned(data_in), 13);
                            state <= compute;
                            flag <= '1';
                        end if;
                        
                    when compute =>
                        if flag = '1' then
                            result <= result + data_3;
                            flag <= '0';
                            state <= output;
                        end if;
                     
                    when output =>
                        data_out <= std_logic_vector(result);
                        valid_out <= '1';
                        addr_out <= addr_in;
                        state <= state_1;
                        data_1 <= (others => '0');
                        data_2 <= (others => '0');
                        data_3 <= (others => '0');
                        result <= (others => '0');
                    
                    end case;
            end if;
        end if;
    end process;
end Behavioral;
