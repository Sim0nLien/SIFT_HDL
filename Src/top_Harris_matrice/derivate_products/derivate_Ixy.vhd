library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity derivate_Ixy is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in  std_logic;
        Ix1          : in  std_logic_vector(12 downto 0);
        Ix2          : in  std_logic_vector(12 downto 0);
        Ix3          : in  std_logic_vector(12 downto 0);
        Iy1          : in  std_logic_vector(12 downto 0);
        Iy2          : in  std_logic_vector(12 downto 0);
        Iy3          : in  std_logic_vector(12 downto 0);
        valid_out   : out std_logic;
        Ixy1        : out std_logic_vector(15 downto 0); -- On travail avec 16 bits à partir de maintenant
        Ixy2        : out std_logic_vector(15 downto 0);
        Ixy3        : out std_logic_vector(15 downto 0)
    );

end derivate_Ixy;

architecture Behavioral of derivate_Ixy is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state : state_type := INIT;

    signal Ix1_reg, Ix2_reg, Ix3_reg : signed(12 downto 0) := (others => '0');
    signal Iy1_reg, Iy2_reg, Iy3_reg : signed(12 downto 0) := (others => '0');
    signal Ixy1_reg, Ixy2_reg, Ixy3_reg : unsigned(25 downto 0) := (others => '0');

begin 

    process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    state <= INIT;
                    valid_out <= '0';
                    Ixy1_reg <= (others => '0');
                    Ixy2_reg <= (others => '0');
                    Ixy3_reg <= (others => '0');

                else
                    case state is
                        when INIT =>
                            valid_out <= '0';
                            Ixy1_reg <= (others => '0');
                            Ixy2_reg <= (others => '0');
                            Ixy3_reg <= (others => '0');
                            state <= WAITING;

                        when WAITING =>
                            valid_out <= '0';
                            if valid_in = '1' then
                                Ix1_reg <= signed(Ix1);
                                Ix2_reg <= signed(Ix2);
                                Ix3_reg <= signed(Ix3);
                                Iy1_reg <= signed(Iy1);
                                Iy2_reg <= signed(Iy2);
                                Iy3_reg <= signed(Iy3);
                                valid_out <= '0';
                                state <= COMPUTE;
                            end if;

                            -- TODO a vérifier je suis pas sûr pour la taille
                        
                        when COMPUTE =>
                            Ixy1_reg <= unsigned(Ix1_reg) * unsigned(Iy1_reg);
                            Ixy2_reg <= unsigned(Ix2_reg) * unsigned(Iy2_reg);
                            Ixy3_reg <= unsigned(Ix3_reg) * unsigned(Iy3_reg);
                            valid_out <= '0';
                            state <= OUTPUT;


                        when OUTPUT =>
                            valid_out <= '1';
                            Ixy1 <= std_logic_vector(Ixy1_reg(25 downto 10));
                            Ixy2 <= std_logic_vector(Ixy2_reg(25 downto 10));
                            Ixy3 <= std_logic_vector(Ixy3_reg(25 downto 10));
                            state <= WAITING;
                           
                    end case;
                end if;
            end if;
        end process;
end Behavioral;


















