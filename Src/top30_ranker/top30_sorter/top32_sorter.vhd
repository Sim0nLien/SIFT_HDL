library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top30_sorter is
    generic(
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 18;
        NB_DATA    : integer := 32
    );
    port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        valid_in    : in  STD_LOGIC;
        data_in     : in  STD_LOGIC_VECTOR(15 downto 0);
        valid_out   : out STD_LOGIC;
        data_out    : out STD_LOGIC_VECTOR(15 downto 0)
    );
end top30_sorter;

architecture Behavioral of top30_sorter is

    type ram_data is array (0 to NB_DATA-1) of unsigned(WIDTH-1 downto 0);
    signal mem_data : ram_data := (others => (others => '0'));

    type ram_addr is array (0 to NB_DATA-1) of unsigned(ADDR_WIDTH-1 downto 0);
    signal mem_addr : ram_addr := (others => (others => '0'));

    signal data : unsigned(DATA_WIDTH-1 downto 0);
    signal addr : unsigned(ADDR_WIDTH-1 downto 0);

    -- I don't know if its the best solution but Its a start
    type state_type is (INIT, WAITING, T00, T10, T11, T20, T21, T22, T23, T30, T31, T32, T33, T34, T35, T36, T37, T40, T41, T42, T43, T44, T45, T46, T47, T48, T49, T410, T411, T412, T413, T414, T415);
    signal current_state : state_type := INIT;

    signal flag : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= INIT;
                mem_data      <= (others => (others => '0'));
                mem_addr      <= (others => (others => '0'));
                valid_out     <= '0';
                data_out      <= (others => '0');

            else
                case current_state is

                    when INIT =>
                        mem_data(0) <= unsigned(data_in);
                        mem_addr(0) <= (others => '0');
                        current_state <= WAITING;

                    when WAITING =>
                        if valid_in = '1' then
                            mem_data(1) <= unsigned(data_in);
                            mem_addr(1) <= (others => '0');
                            current_state <= T00;
                        end if;

                    when T00 =>
                        if unsigned(data_in) < mem_data(16) then
                            state <= T10;
                        elsif
                            state <= T11;
                        end if;

                    when T10 => 
                        if unsigned (data_in) < mem_data(8) then 
                            state <= T20;
                        elsif 
                            state <= T21;
                        end if;
                    
                    when T11 =>
                        if unsigned (data_in) < mem_data(24) then
                            state <= T22;
                        elsif
                            state <= T23;
                        end if;

                    when T20 =>
                        if unsigned (data_in) < mem_data(4) then
                            state <= T30;
                        elsif
                            state <= T31;
                        end if;

                    when T21 =>
                        if unsigned (data_in) < mem_data(12) then
                            state <= T32;
                        elsif
                            state <= T33;
                        end if;

                    when T22 =>
                        if unsigned (data_in) < mem_data(20) then
                            state <= T34;
                        elsif
                            state <= T35;
                        end if;
                       
                    when T23 =>
                        if unsigned (data_in) < mem_data(28) then
                            state <= T36;
                        elsif
                            state <= T37;

                    when T30 =>
                        if unsigned (data_in) < mem_data(2) then
                            state <= T40;
                        elsif
                            state <= T41;
                        end if;

                    when T31 =>
                        if unsigned (data_in) < mem_data(6) then
                            state <= T42;
                        elsif
                            state <= T43;
                        end if;

                    when T32 =>
                        if unsigned (data_in) < mem_data(10) then
                            state <= T44;
                        elsif
                            state <= T45;
                        end if;

                    when T33 =>
                        if unsigned (data_in) < mem_data(14) then
                            state <= T46;
                        elsif
                            state <= T47;
                        end if;

                    when T34 =>
                        if unsigned (data_in) < mem_data(18) then
                            state <= T48;
                        elsif
                            state <= T49;
                        end if;

                    when T35 =>
                        if unsigned (data_in) < mem_data(22) then
                            state <= T410;
                        elsif
                            state <= T411;
                        end if;

                    when T36 =>
                        if unsigned (data_in) < mem_data(26) then
                            state <= T412;
                        elsif
                            state <= T413;
                        end if;

                    when T37 =>
                        if unsigned (data_in) < mem_data(30) then
                            state <= T414;
                        elsif
                            state <= T415;
                        end if;

                    when T40 =>
                        if unsigned (data_in) < mem_data(1) then
                            mem_data(0) <= data_in;
                        elsif
                            mem_data(0) <= mem_data(1); -- I don't know if a better way to write this exist
                            mem_data(1) <= data_in;

                    when T41 =>
                        if unsigned (data_in) < mem_data(3) then
                            mem_data(0) <= mem_data(1);
                            mem_data(2) <= 








end Behavioral;





