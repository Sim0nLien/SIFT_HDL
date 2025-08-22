library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity harris_response is
    port (
        clk                : in  STD_LOGIC;
        reset              : in  STD_LOGIC;
        valid_determinant  : in  STD_LOGIC;
        valid_trace        : in  STD_LOGIC;
        harris_determinant : in  STD_LOGIC_VECTOR(15 downto 0);
        harris_trace       : in  STD_LOGIC_VECTOR(15 downto 0);
        valid_out          : out STD_LOGIC;
        output             : out STD_LOGIC_VECTOR(15 downto 0)
    );
end harris_response;

architecture Behavioral of harris_response is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);

    signal current_state : state_type := INIT;
    signal next_state    : state_type := INIT;

    signal flag_determinant : STD_LOGIC := '0';
    signal flag_trace       : STD_LOGIC := '0';

    signal determinant_reg  : signed(15 downto 0) := (others => '0');
    signal trace_reg        : unsigned(15 downto 0) := (others => '0');

    signal response_reg     : signed(15 downto 0) := (others => '0');

    signal count            : integer := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state    <= INIT;
                next_state       <= INIT;
                flag_determinant <= '0';
                flag_trace       <= '0';
                determinant_reg  <= (others => '0');
                trace_reg        <= (others => '0');
                response_reg     <= (others => '0');
                valid_out        <= '0';
                output  <= (others => '0');
                count            <= 0;

            else
                current_state <= next_state;

                case current_state is

                    when INIT =>
                        flag_determinant <= '0';
                        flag_trace       <= '0';
                        determinant_reg  <= (others => '0');
                        trace_reg        <= (others => '0');
                        response_reg     <= (others => '0');
                        valid_out        <= '0';
                        next_state       <= WAITING;

                    when WAITING =>
                        valid_out <= '0';
                        
                        if valid_determinant = '1' then
                            flag_determinant <= '1';
                            determinant_reg  <= signed(harris_determinant);
                        end if;

                        if valid_trace = '1' then
                            flag_trace <= '1';
                            trace_reg  <= unsigned(harris_trace);
                        end if;

                        if flag_determinant = '1' and flag_trace = '1' then
                            next_state       <= COMPUTE;
                            flag_determinant <= '0';
                            flag_trace       <= '0';
                        else
                            next_state <= WAITING;
                        end if;

                    when COMPUTE =>
                        if count = 0 then
                            response_reg <= signed(shift_right(trace_reg, 4)) - signed(shift_right(trace_reg, 6));
                            count        <= 1;
                            next_state   <= COMPUTE;

                        elsif count = 1 then
                            response_reg <= determinant_reg - response_reg;
                            count        <= 0;
                            next_state   <= OUTPUT;
                        end if;

                    when OUTPUT =>
                        output <= std_logic_vector(response_reg);
                        valid_out       <= '1';
                        next_state      <= WAITING;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
