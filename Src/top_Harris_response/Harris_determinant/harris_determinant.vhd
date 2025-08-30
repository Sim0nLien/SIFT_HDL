library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity harris_determinant is
    port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        valid_Ixx  : in  STD_LOGIC;
        valid_Ixy  : in  STD_LOGIC;
        valid_Iyy  : in  STD_LOGIC;
        Ixx        : in  STD_LOGIC_VECTOR(15 downto 0);
        Ixy        : in  STD_LOGIC_VECTOR(15 downto 0);
        Iyy        : in  STD_LOGIC_VECTOR(15 downto 0);
        valid_out  : out STD_LOGIC;
        det        : out STD_LOGIC_VECTOR(15 downto 0)  
    );
end harris_determinant;

architecture Behavioral of harris_determinant is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state : state_type := INIT;

    signal Ixx_reg, Ixy_reg, Iyy_reg : signed(15 downto 0) := (others => '0');

    signal temp_result_1, temp_result_2 : signed(31 downto 0) := (others => '0');
    signal diff_res   : signed(31 downto 0) := (others => '0');  -- intermédiaire
    signal det_reg    : signed(15 downto 0) := (others => '0');

    signal valid_out_reg : STD_LOGIC := '0';

    signal flag_Ixx      : STD_LOGIC := '0';
    signal flag_Ixy      : STD_LOGIC := '0';
    signal flag_Iyy      : STD_LOGIC := '0';

    signal flag : STD_LOGIC := '0';  
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state          <= INIT;
                valid_out_reg  <= '0';
                flag_Ixx       <= '0';
                flag_Ixy       <= '0';
                flag_Iyy       <= '0';
                Ixx_reg        <= (others => '0');
                Ixy_reg        <= (others => '0');
                Iyy_reg        <= (others => '0');
                temp_result_1  <= (others => '0');
                temp_result_2  <= (others => '0');
                diff_res       <= (others => '0');
                det_reg        <= (others => '0');
                valid_out_reg  <= '0';

            else
                case state is

                    when INIT =>
                        flag_Ixx      <= '0';
                        flag_Ixy      <= '0';
                        flag_Iyy      <= '0';
                        Ixx_reg       <= (others => '0');
                        Ixy_reg       <= (others => '0');
                        Iyy_reg       <= (others => '0');
                        temp_result_1 <= (others => '0');
                        temp_result_2 <= (others => '0');
                        diff_res      <= (others => '0');
                        det_reg       <= (others => '0');
                        state         <= WAITING;
-- TODO : j'aime pas a revoir
                    when WAITING =>
                        valid_out_reg <= '0';
                        if valid_Ixx = '1' then
                            Ixx_reg <= signed(Ixx);
                            flag_Ixx <= '1';
                        end if;
                        if valid_Ixy = '1' then
                            Ixy_reg <= signed(Ixy);
                            flag_Ixy <= '1';
                        end if;
                        if valid_Iyy = '1' then
                            Iyy_reg <= signed(Iyy);
                            flag_Iyy <= '1';
                        end if;
                        if flag_Ixx = '1' and flag_Ixy = '1' and flag_Iyy = '1' then
                            state   <= COMPUTE;
                        end if;

                    when COMPUTE =>
                        flag_Ixx <= '0';
                        flag_Ixy <= '0';
                        flag_Iyy <= '0';
                        if flag = '0' then
                            temp_result_1 <= Ixx_reg * Iyy_reg;
                            temp_result_2 <= Ixy_reg * Ixy_reg;
                            flag <= '1';
                        elsif flag = '1' then
                            state         <= OUTPUT;
                            diff_res      <= temp_result_1 - temp_result_2;
                            flag <= '0';
                        end if;

                    when OUTPUT =>
                        det_reg       <= diff_res(31 downto 16);  -- slice valide
                        valid_out_reg <= '1';
                        state         <= WAITING;

                end case;
            end if;
        end if;
    end process;

    -- Sorties
    det       <= std_logic_vector(det_reg);
    valid_out <= valid_out_reg;

end Behavioral;
