library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity harris_trace is
    port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        valid_Ixx : in  STD_LOGIC;
        valid_Iyy : in  STD_LOGIC;
        Ixx       : in  STD_LOGIC_VECTOR(15 downto 0);
        Iyy       : in  STD_LOGIC_VECTOR(15 downto 0);
        valid_out : out STD_LOGIC;
        trace     : out STD_LOGIC_VECTOR(15 downto 0)
    );
end harris_trace;


architecture Behavioral of harris_trace is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state : state_type := INIT;

    signal Ixx_reg, Iyy_reg : unsigned(15 downto 0) := (others => '0');
    signal tmp_trace_1        : unsigned(15 downto 0) := (others => '0');
    signal tmp_trace_2       : unsigned(31 downto 0) := (others => '0');

    signal flag_Ixx          : STD_LOGIC := '0';
    signal flag_Iyy          : STD_LOGIC := '0';

    signal flag              : STD_LOGIC := '0';

begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state          <= INIT;
                Ixx_reg        <= (others => '0');
                Iyy_reg        <= (others => '0');
                flag_Ixx      <= '0';
                flag_Iyy      <= '0';

            else
                case state is

                    when INIT =>
                        Ixx_reg       <= (others => '0');
                        Iyy_reg       <= (others => '0');
                        state         <= WAITING;
                        flag_Ixx     <= '0';
                        flag_Iyy     <= '0';

                    when WAITING =>
                        valid_out <= '0';
                        if valid_Ixx = '1' then
                            flag_Ixx <= '1';
                            Ixx_reg <= unsigned(Ixx);
                        end if;
                        if valid_Iyy = '1' then
                            flag_Iyy <= '1';
                            Iyy_reg <= unsigned(Iyy);
                        end if;
                        if flag_Iyy = '1' and flag_Ixx = '1' then
                            state <= COMPUTE;
                        end if;

                    when COMPUTE =>
                        flag_Ixx <= '0';
                        flag_Iyy <= '0';
                        if flag = '0' then
                            flag <= '1';
                            tmp_trace_1 <= Ixx_reg + Iyy_reg;
                        elsif flag = '1' then
                            tmp_trace_2 <= tmp_trace_1 * tmp_trace_1;  -- slice valide
                            state <= OUTPUT;
                            flag <= '0';
                        end if;

                    when OUTPUT =>
                        valid_out <= '1';
                        trace     <= std_logic_vector(tmp_trace_2(31 downto 16));
                        state     <= WAITING;
                    end case;
                end if;
            end if;
        end process;
    end Behavioral;

                        