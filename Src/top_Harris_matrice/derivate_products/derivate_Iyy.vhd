library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-- note : non testé, je suppose que c'est bon


entity derivate_Iyy is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in  std_logic;
        Iy1          : in  std_logic_vector(12 downto 0);
        Iy2          : in  std_logic_vector(12 downto 0);
        Iy3          : in  std_logic_vector(12 downto 0);
        valid_out   : out std_logic;
        Iyy1        : out std_logic_vector(15 downto 0); -- On travail avec 16 bits à partir de maintenant
        Iyy2        : out std_logic_vector(15 downto 0);
        Iyy3        : out std_logic_vector(15 downto 0)
    );

end derivate_Iyy;

architecture Behavioral of derivate_Iyy is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state : state_type := INIT;

    signal Iy1_reg, Iy2_reg, Iy3_reg : signed(12 downto 0) := (others => '0');
    signal Iyy1_reg, Iyy2_reg, Iyy3_reg : unsigned(25 downto 0) := (others => '0');

begin 

    process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    state <= INIT;
                    valid_out <= '0';
                    Iyy1_reg <= (others => '0');
                    Iyy2_reg <= (others => '0');
                    Iyy3_reg <= (others => '0');

                else
                    case state is
                        when INIT =>
                            valid_out <= '0';
                            Iyy1_reg <= (others => '0');
                            Iyy2_reg <= (others => '0');
                            Iyy3_reg <= (others => '0');
                            state <= WAITING;

                        when WAITING =>
                            valid_out <= '0';
                            if valid_in = '1' then
                                Iy1_reg <= signed(Iy1);
                                Iy2_reg <= signed(Iy2);
                                Iy3_reg <= signed(Iy3);
                                valid_out <= '0';
                                state <= COMPUTE;
                            end if;
                        
                        when COMPUTE =>
                            Iyy1_reg <= unsigned(Iy1_reg) * unsigned(Iy1_reg);
                            Iyy2_reg <= unsigned(Iy2_reg) * unsigned(Iy2_reg);
                            Iyy3_reg <= unsigned(Iy3_reg) * unsigned(Iy3_reg);
                            valid_out <= '0';
                            state <= OUTPUT;


                        when OUTPUT =>
                            valid_out <= '1';
                            Iyy1 <= std_logic_vector(Iyy1_reg(25 downto 10));
                            Iyy2 <= std_logic_vector(Iyy2_reg(25 downto 10));
                            Iyy3 <= std_logic_vector(Iyy3_reg(25 downto 10));
                            state <= WAITING;
                           
                    end case;
                end if;
            end if;
        end process;
end Behavioral;


















