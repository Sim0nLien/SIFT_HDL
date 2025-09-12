library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity read_image is
    port(
        clk             : in  std_logic;
        reset           : in  std_logic;
        valid_ram_in    : in std_logic;
        valid_manager_in: in std_logic;
        data_in         : in std_logic_vector(7 downto 0);
        addr_manager    : in std_logic_vector(17 downto 0);
        valid_ram_out   : out std_logic;
        valid_mem_out   : out std_logic;
        addr_order      : out std_logic_vector(17 downto 0);
        addr_out        : out std_logic_vector(17 downto 0);
        data_out        : out std_logic_vector(7 downto 0)
    );
end read_image;
  
architecture Behavioral of read_image is
    
    type state_type is (INIT, WAITING, SEND_REQUEST, SEND_DATA);
    signal state : state_type := INIT;

    signal count : integer := 0;
    signal addr_pix : unsigned(17 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                valid_mem_out <= '0';
                valid_ram_out <= '0';
                addr_out <= (others => '0');
                data_out <= (others => '0');
                count <= 0;

            else
                case state is
                    when INIT =>
                        valid_mem_out <= '0';
                        valid_ram_out <= '0';
                        state <= WAITING;
                        count <= 0;

                    when WAITING =>
                        valid_mem_out <= '0';
                        valid_ram_out <= '0';
                        count <= 0;
                        if valid_manager_in = '1' then
                           state <= SEND_REQUEST;
                           addr_pix <= unsigned(addr_manager) - 512;
                        end if;

                    when SEND_REQUEST =>
                        valid_ram_out <= '1';
                        valid_mem_out <= '0';
                        addr_order <= std_logic_vector(addr_pix);
                        state <= SEND_DATA;

                    when SEND_DATA =>
                        valid_ram_out <= '0';
                        valid_mem_out <= '1';
                        if valid_ram_in = '1' then
                            data_out <= data_in;
                            addr_pix <= addr_pix + 512;
                            addr_out <= std_logic_vector(addr_pix);
                            state <= SEND_REQUEST;
                            count <= count + 1;
                            if count = 2 then
                                state <= WAITING;
                            end if;
                        end if;
                    end case;
            end if;
        end if;
    end process;
end Behavioral;


                            




