library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ranking_threshold is
    port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        valid_in        : in  STD_LOGIC;
        valid_threshold : in  STD_LOGIC;
        data_in         : in  STD_LOGIC_VECTOR(15 downto 0);
        threshold       : in  STD_LOGIC_VECTOR(15 downto 0);
        valid_out       : out STD_LOGIC;
        data_out        : out STD_LOGIC_VECTOR(15 downto 0)
    );
end ranking_threshold;

architecture Behavioral of ranking_threshold is
begin


    type state_type is (INIT, WAITING, COMPARE, UPDATE);
    signal state : state_type := INIT;

    signal data_reg : signed(15 downto 0) := (others => '0');
    signal threshold_reg : signed(15 downto 0) := (others => '0');

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

            else
                case state is
                    when INIT =>
                        data_reg      <= (others => '0');
                        threshold_reg <= (others => '0');
                        valid_out     <= '0';
                        data_out      <= (others => '0');
                        state         <= WAITING;

                    when WAITING =>
                        valid_out <= '0';
                        if valid_threshold = '1' then
                            state <= UPDATE;
                        else if valid_in = '1' then 
                            state <= COMPARE;
                        end if;
                    
                    when COMPARE =>
                        if valid_threshold = '1' then
                            state <= UPDATE;
                            flag <= '1'; -- In the case new threshold while comparing
                        else
                            if data_reg > threshold_reg then
                                data_out  <= std_logic_vector(data_reg);
                                valid_out <= '1';
                            else
                                data_out  <= (others => '0');
                                valid_out <= '0';
                            end if;
                            state <= WAITING;
                        end if;
                        
                    when UPDATE =>
                        threshold_reg <= signed(threshold);
                        if flag = '1' then
                            state <= COMPARE;
                            flag <= '0';
                        end if;

                end case;
            end if;
        end if;
    end process;
end Behavioral;














