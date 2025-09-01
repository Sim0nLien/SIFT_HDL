library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- In this bloc, I consider the new_threshold_time faster than the data arrival time

entity ranking_threshold is
    port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        valid_in        : in  STD_LOGIC;
        valid_threshold : in  STD_LOGIC;
        data_in         : in  STD_LOGIC_VECTOR(15 downto 0);
        threshold       : in  STD_LOGIC_VECTOR(15 downto 0);
        end_comparing   : out  STD_LOGIC;
        valid_out       : out STD_LOGIC;
        data_out        : out STD_LOGIC_VECTOR(15 downto 0)
    );
end ranking_threshold;

architecture Behavioral of ranking_threshold is



    type state_type is (INIT, WAITING, COMPARE, UPDATE);
    signal state : state_type := INIT;

    signal data_reg : signed(15 downto 0) := (others => '0');
    signal threshold_reg : signed(15 downto 0) := (others => '0');
    
    signal flag : std_logic;

begin 

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state         <= INIT;
                data_reg      <= (others => '0');
                threshold_reg <= (others => '0');
                valid_out     <= '0';
                data_out      <= (others => '0');
                end_comparing <= '0';
                flag          <= '0';

            else
                case state is
                    when INIT =>
                        data_reg      <= (others => '0');
                        threshold_reg <= (others => '0');
                        valid_out     <= '0';
                        data_out      <= (others => '0');
                        state         <= WAITING;
                        end_comparing <= '0';
                        flag          <= '0';


                    when WAITING =>
                        valid_out <= '0';
                        end_comparing <= '0';
                        if valid_in = '1' then 
                            state <= COMPARE;
                            data_reg <= signed(data_in);
                            flag <= '1';
                        end if;
                        if valid_threshold = '1' then
                            state <= UPDATE;
                        end if;
                    
                    when COMPARE =>
                        if data_reg > threshold_reg then
                            data_out  <= std_logic_vector(data_reg);
                            valid_out <= '1';
                        else
                            data_out  <= (others => '0');
                            valid_out <= '0';
                        end if;
                        state <= WAITING;
                        end_comparing <= '1';
                        
                    when UPDATE =>
                        threshold_reg <= signed(threshold);
                        state <= WAITING;
                        if flag = '1' then
                            state <= COMPARE;
                            flag <= '0';
                        end if;

                end case;
            end if;
        end if;
    end process;
end Behavioral;














