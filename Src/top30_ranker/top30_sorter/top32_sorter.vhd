library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Function all_addrs, not tested yet
entity top30_sorter is
    generic(
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 18;
        NB_DATA    : integer := 32
    );
    port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        valid_in      : in  STD_LOGIC;
        data_in       : in  STD_LOGIC_VECTOR(15 downto 0);
        addr_in       : in STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        give_data     : in  STD_LOGIC; -- Turn on when you want get all data & addr
        valid_out     : out STD_LOGIC;
        data_out      : out STD_LOGIC_VECTOR(15 downto 0);
        addr_out      : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
        all_addrs     : out STD_LOGIC_VECTOR((NB_DATA*ADDR_WIDTH)-1 downto 0)
    );
end top30_sorter;

architecture Behavioral of top30_sorter is

    type ram_data is array (0 to NB_DATA-1) of unsigned(DATA_WIDTH-1 downto 0);
    signal mem_data : ram_data := (others => (others => '0'));

    type ram_addr is array (0 to NB_DATA-1) of unsigned(ADDR_WIDTH-1 downto 0);
    signal mem_addr : ram_addr := (others => (others => '0'));

    signal data : unsigned(DATA_WIDTH-1 downto 0);
    signal addr : unsigned(ADDR_WIDTH-1 downto 0);

    -- I don't know if its the best solution but Its a start
    type state_type is (INIT, WAITING, T00, T10, T11, T20, T21, T22, T23, T30, T31, T32, T33, T34, T35, T36, T37, T40, T41, T42, T43, T44, T45, T46, T47, T48, T49, T410, T411, T412, T413, T414, T415);
    signal state : state_type := INIT;

    signal flag : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                mem_data      <= (others => (others => '0'));
                mem_addr      <= (others => (others => '0'));
                valid_out     <= '0';
                data_out      <= (others => '0');

            else
                case state is

                    when INIT =>
                        mem_data(0) <= unsigned(data_in);
                        mem_addr(0) <= (others => '0');
                        state <= WAITING;
                        valid_out <= '0';

                    when WAITING =>
                        valid_out <= '0';
                        if valid_in = '1' then
                            state <= T00;
                            data <= unsigned(data_in);
                        end if;

                    when T00 =>
                        if data < mem_data(16) then
                            state <= T10;
                        else
                            state <= T11;
                        end if;

                    when T10 => 
                        if data < mem_data(8) then 
                            state <= T20;
                        else 
                            state <= T21;
                        end if;
                    
                    when T11 =>
                        if data < mem_data(24) then
                            state <= T22;
                        else
                            state <= T23;
                        end if;

                    when T20 =>
                        if data < mem_data(4) then
                            state <= T30;
                        else
                            state <= T31;
                        end if;

                    when T21 =>
                        if data < mem_data(12) then
                            state <= T32;
                        else
                            state <= T33;
                        end if;

                    when T22 =>
                        if data < mem_data(20) then
                            state <= T34;
                        else
                            state <= T35;
                        end if;
                       
                    when T23 =>
                        if data < mem_data(28) then
                            state <= T36;
                        else
                            state <= T37;
                         end if;

                    when T30 =>
                        if data < mem_data(2) then
                            state <= T40;
                        else
                            state <= T41;
                        end if;

                    when T31 =>
                        if data < mem_data(6) then
                            state <= T42;
                        else
                            state <= T43;
                        end if;

                    when T32 =>
                        if data < mem_data(10) then
                            state <= T44;
                        else
                            state <= T45;
                        end if;

                    when T33 =>
                        if data < mem_data(14) then
                            state <= T46;
                        else
                            state <= T47;
                        end if;

                    when T34 =>
                        if data < mem_data(18) then
                            state <= T48;
                        else
                            state <= T49;
                        end if;

                    when T35 =>
                        if data < mem_data(22) then
                            state <= T410;
                        else
                            state <= T411;
                        end if;

                    when T36 =>
                        if data < mem_data(26) then
                            state <= T412;
                        else
                            state <= T413;
                        end if;

                    when T37 =>
                        if data < mem_data(30) then
                            state <= T414;
                        else
                            state <= T415;
                        end if;

                    when T40 =>
                        if data < mem_data(1) then
                            mem_data(0) <= data;
                        else
                            mem_data(0) <= mem_data(1); -- I don't know if a better way to write this exist
                            mem_data(1) <= data;
                    end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));


                    when T41 =>
                        mem_data(0) <= mem_data(1);
                        mem_data(1) <= mem_data(2);
                        if data < mem_data(3) then
                            mem_data(2) <= data;
                        else
                            mem_data(2) <= mem_data(3);
                            mem_data(3) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));
                    
                    
                    when T42 =>
                        for i in 0 to 3 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(5) then
                            mem_data(4) <= data;
                        else
                            mem_data(4) <= mem_data(5);
                            mem_data(5) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));


                    when T43 =>
                        for i in 0 to 5 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(7) then
                            mem_data(6) <= data;
                        else
                            mem_data(6) <= mem_data(7);
                            mem_data(7) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));


                    when T44 =>
                        for i in 0 to 7 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(9) then
                            mem_data(8) <= data;
                        else
                            mem_data(8) <= mem_data(9);
                            mem_data(9) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));


                    when T45 =>
                        for i in 0 to 9 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(11) then
                            mem_data(10) <= data;
                        else
                            mem_data(10) <= mem_data(11);
                            mem_data(11) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));


                    when T46 =>
                        for i in 0 to 11 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(13) then
                            mem_data(12) <= data;
                        else
                            mem_data(12) <= mem_data(13);
                            mem_data(13) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));


                    when T47 =>
                        for i in 0 to 13 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(15) then
                            mem_data(14) <= data;
                        else
                            mem_data(14) <= mem_data(15);
                            mem_data(15) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));

                    
                    when T48 =>
                        for i in 0 to 15 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(17) then
                            mem_data(16) <= data;
                        else
                            mem_data(16) <= mem_data(17);
                            mem_data(17) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));

                    
                    when T49 =>
                        for i in 0 to 17 loop
                            mem_data(i) <= mem_data(i+1); 
                        end loop;
                        if data < mem_data(19) then
                            mem_data(18) <= data;
                        else
                            mem_data(18) <= mem_data(19);
                            mem_data(19) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));

                    
                    when T410 =>
                        for i in 0 to 19 loop
                            mem_data(i) <= mem_data(i+1);
                        end loop;
                        if data < mem_data(21) then
                            mem_data(20) <= data;
                        else
                            mem_data(20) <= mem_data(21);
                            mem_data(21) <= data;
                        end if;
                    state <= WAITING;
                    valid_out <= '1';
                    data_out <= std_logic_vector(mem_data(0));

                
                    when T411 =>
                        for i in 0 to 21 loop
                            mem_data(i) <= mem_data(i+1);
                        end loop;
                        if data < mem_data(23) then
                            mem_data(22) <= data;
                        else
                            mem_data(22) <= mem_data(23);
                            mem_data(23) <= data;
                            end if;
                        state <= WAITING;
                        valid_out <= '1';
                        data_out <= std_logic_vector(mem_data(0));

                    when T412 =>
                        for i in 0 to 23 loop
                            mem_data(i) <= mem_data(i+1);
                        end loop;
                        if data < mem_data(25) then
                            mem_data(24) <= data;
                        else
                            mem_data(24) <= mem_data(25);
                            mem_data(25) <= data;
                            end if;
                        state <= WAITING;
                        valid_out <= '1';
                        data_out <= std_logic_vector(mem_data(0));


                    when T413 =>
                        for i in 0 to 25 loop
                            mem_data(i) <= mem_data(i+1);
                        end loop;
                        if data < mem_data(27) then
                            mem_data(26) <= data;
                        else
                            mem_data(26) <= mem_data(27);
                            mem_data(27) <= data;
                            end if;
                        state <= WAITING;
                        valid_out <= '1';
                        data_out <= std_logic_vector(mem_data(0));


                    when T414 =>
                        for i in 0 to 27 loop
                            mem_data(i) <= mem_data(i+1);
                        end loop;
                        if data < mem_data(29) then
                            mem_data(28) <= data;
                        else 
                            mem_data(28) <= mem_data(29);
                            mem_data(29) <= data;
                        end if;
                        state <= WAITING;
                        valid_out <= '1';
                        data_out <= std_logic_vector(mem_data(0));


                    when T415 =>
                        for i in 0 to 29 loop
                            mem_data(i) <= mem_data(i+1);
                        end loop;
                        if data < mem_data(31) then
                            mem_data(30) <= data;
                        else
                            mem_data(30) <= mem_data(31);
                            mem_data(31) <= data;
                        end if;
                        state <= WAITING;
                        valid_out <= '1';
                        data_out <= std_logic_vector(mem_data(0));
                    end case;
                end if;
            end if;
    end process;
end Behavioral;
