library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity gaussian_conv is
    Port ( clk       : in STD_LOGIC;
           reset     : in STD_LOGIC;
           valid_in  : in STD_LOGIC;
           I1        : in STD_LOGIC_VECTOR(15 downto 0);
           I2        : in STD_LOGIC_VECTOR(15 downto 0);
           I3        : in STD_LOGIC_VECTOR(15 downto 0);
           valid_out : out STD_LOGIC;
           res       : out STD_LOGIC_VECTOR(15 downto 0)
    );

end gaussian_conv;

architecture Behavioral of gaussian_conv is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state : state_type := INIT;

    signal I1_reg, I2_reg, I3_reg : unsigned(15 downto 0) := (others => '0');
    signal C1_reg, C2_reg, C3_reg : unsigned(15 downto 0) := (others => '0');
    signal R_reg : unsigned(15 downto 0) := (others => '0');


    signal count : integer := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                valid_out <= '0';
                I1_reg <= (others => '0');
                I2_reg <= (others => '0');
                I3_reg <= (others => '0');
                C1_reg <= (others => '0');
                C2_reg <= (others => '0');
                C3_reg <= (others => '0');
            
            else
                case state is
                    when INIT =>
                        valid_out <= '0';
                        I1_reg <= (others => '0');
                        I2_reg <= (others => '0');
                        I3_reg <= (others => '0');
                        C1_reg <= (others => '0');
                        C2_reg <= (others => '0');
                        C3_reg <= (others => '0');
                        state <= WAITING;

                    when WAITING =>
                        valid_out <= '0';
                        if valid_in = '1' then
                            I1_reg <= unsigned(I1);
                            I2_reg <= unsigned(I2);
                            I3_reg <= unsigned(I3);
                            state <= COMPUTE;
                        end if;

                    when COMPUTE => -- 3 coups d'horloge
                        if count = 0 then
                            C3_reg <= (I1_reg + I2_reg + I2_reg + I3_reg);
                            count <= 1;
                        elsif count = 1 then
                            R_reg <= (C1_reg + C2_reg + C2_reg + C3_reg);
                            count <= 2;
                        elsif count = 2 then
                            C1_reg <= C2_reg;
                            C2_reg <= C3_reg;
                            state <= OUTPUT;   
                            count <= 0; 
                        end if;                    

                    when OUTPUT =>
                        valid_out <= '1';
                        res <= std_logic_vector(R_reg);
                        state <= WAITING;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
















