library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity conv_sobel_horizontal is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in  std_logic;
        pixel_in    : in  std_logic_vector(7 downto 0);
        valid_back  : out std_logic;
        valid_out   : out std_logic;
        result_out  : out std_logic_vector(13 downto 0)
    );
end conv_sobel_horizontal;

architecture Behavioral of conv_sobel_horizontal is

    type state_type is (INIT, LOAD_0, LOAD_1, LOAD_2, COMPUTE);
    signal step_count : integer := 0;

    signal state       : state_type := INIT;
    signal pixel_buf  : std_logic_vector(7 downto 0) := (others => '0');
    
    signal buffer_0  : unsigned(10 downto 0) := (others => '0');
    signal buffer_2  : unsigned(10 downto 0) := (others => '0');
    signal buffer_3  : unsigned(10 downto 0) := (others => '0');
    signal buffer_5  : unsigned(10 downto 0) := (others => '0');
    signal buffer_6  : unsigned(10 downto 0) := (others => '0');-
    signal buffer_8  : unsigned(10 downto 0) := (others => '0');

    signal buffer_line_0 : unsigned(11 downto 0) := (others => '0');
    signal buffer_line_1 : unsigned(11 downto 0) := (others => '0');

    signal result : signed(13 downto 0) := (others => '0');

begin

    process (clk)

    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                valid_back <= '0';
                valid_out <= '0';
                result_out <= (others => '0');
                pixel_buf <= (others => '0');
        
            else
                case state is
                    when INIT =>
                        valid_out <= '0';
                        result_out <= (others => '0');
                        valid_back <= '1';
                        state <= LOAD_0;
                        step_count <= 0;

                    when LOAD_0 =>
                        case step_count is
                            when 0 =>
                                valid_back <= '0';
                                if valid_in = '1' then
                                    buffer_0 <= unsigned(pixel_in);
                                    step_count <= step_count + 1;
                                end if;

                            when 1 =>
                                valid_back <= '1';
                                state <= LOAD_1;
                                step_count <= 0;
                            
                            when others =>
                                state <= INIT;
                        end case;



                    when LOAD_1 =>
                        case step_count is
                            when 0 =>
                                valid_back <= '0';
                                if valid_in = '1' then
                                    buffer_1 <= unsigned(pixel_in);
                                    step_count <= step_count + 1;
                                end if;

                            when 1 =>
                                valid_back <= '1';
                                state <= LOAD_2;
                                step_count <= 0;

                            when others =>
                                state <= INIT;

                        end case;
                    
                    when LOAD_2 =>
                        case step_count is
                            when 0 =>
                                valid_back <= '0';
                                if valid_in = '1' then
                                    buffer_2 <= unsigned(pixel_in);
                                    step_count <= step_count + 1;
                                end if;
                            
                            when 1 =>
                                valid_back <= '1';
                                state <= COMPUTE;
                                step_count <= 0;

                            when others =>
                                state <= INIT;
                        end case;

                    when COMPUTE =>
                        case step_count is
                            when 0 =>
                                valid_back <= '0';
                                buffer_line_0 <= resize(buffer_0, 12) +
                                                 resize(buffer_3 * 2, 12) +
                                                 resize(buffer_6, 12);
                                buffer_line_1 <= resize(buffer_2, 12) +
                                                 resize(buffer_5 * 2, 12) +
                                                 resize(buffer_8, 12);
                                step_count <= step_count + 1;
                            
                            when 1 =>
                                result <= resize(signed(buffer_line_0) - signed(buffer_line_1), 14);
                                step_count <= step_count + 1;
                            
                            when 2 =>
                                result_out <= std_logic_vector(result);
                                valid_out <= '1';
                                state <= INIT;
                                step_count <= 0;

                            when others =>
                                state <= INIT;
                        end case;
                    
                    when others =>
                        state <= INIT;
                end case;
            end if;
        end if;
    end process;
end Behavioral;

















