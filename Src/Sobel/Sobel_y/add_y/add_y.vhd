library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity add_y is
    Port ( clk          : in STD_LOGIC;
           reset        : in STD_LOGIC;
           valid_in_1   : in STD_LOGIC;
           valid_in_2   : in STD_LOGIC;
           valid_in_3   : in STD_LOGIC;
           data_in_1    : in STD_LOGIC_VECTOR (12 downto 0);
           data_in_2    : in STD_LOGIC_VECTOR (12 downto 0);
           data_in_3    : in STD_LOGIC_VECTOR (12 downto 0);
           addr_in      : in STD_LOGIC_VECTOR (17 downto 0);
           valid_out    : out STD_LOGIC;
           data_out     : out STD_LOGIC_VECTOR (13 downto 0);
           addr_out     : out STD_LOGIC_VECTOR (17 downto 0);
    );
end add_y;

architecture Behavioral of add_y is

    type state_type is (INIT, WAITING, COMPUTE, OUTPUT);
    signal state     : state_type := INIT;

    signal flag_1  : STD_LOGIC := '0';
    signal flag_2  : STD_LOGIC := '0';
    signal flag_3  : STD_LOGIC := '0';

    signal data_1  : signed(12 downto 0) := (others => '0');
    signal data_2  : signed(12 downto 0) := (others => '0');
    signal data_3  : signed(12 downto 0) := (others => '0');

    signal result  : signed(13 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                data_1 <= (others => '0');
                data_2 <= (others => '0');
                data_3 <= (others => '0');
                addr_out <= (others => '0');
                data_out <= (others => '0');
                valid_out <= '0';
                flag_1 <= '0';
                flag_2 <= '0';
                flag_3 <= '0';
            
            else
                case state is
                    when INIT =>
                        state <= WAITING;
                        
                    when WAITING =>
                        valid_out <= '0';
                        
                        if valid_in_1 = '1' then
                            data_1 <= resize(signed(data_in_1), 13);
                            flag_1 <= '1';
                        end if;
                        
                        if valid_in_2 = '1' then
                            data_2 <= resize(signed(data_in_2), 13);
                            flag_2 <= '1';
                        end if;
                        
                        if valid_in_3 = '1' then
                            data_3 <= resize(signed(data_in_3), 13);
                            flag_3 <= '1';
                        end if;
                        
                        if (flag_1 = '1') and (flag_2 = '1') and (flag_3 = '1') then
                            state <= COMPUTE;
                            addr_out <= addr_in;
                        end if;
                        
                    when COMPUTE =>
                        result <= data_1 + data_2 + data_3;
                        state <= OUTPUT;
                        
                    when OUTPUT =>
                        valid_out <= '1';
                        data_out <= std_logic_vector(result);
                        state <= WAITING;
                        flag_1 <= '0';
                        flag_2 <= '0';
                        flag_3 <= '0';
                        
                end case;
            end if;          
        end if;
    end process;
end Behvioral;

