library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

 

entity harris_matrice_manager is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_next  : in  std_logic;
        coord_out   : out std_logic_vector(18 downto 0); -- a vérifier
        valid_out   : out std_logic
    );

end harris_matrice_manager;

architecture Behavioral of harris_matrice_manager is
    
    type state_type is (INIT, ADD, WAITING, OUTPUT);

    signal state : state_type := INIT;

    signal addr  : integer := 513; 
    signal count : integer := 0;

    signal flag  : std_logic := '0';

begin
    process (clk)
        begin
             if rising_edge(clk) then
                if reset = '1' then
                    state <= INIT;
                    valid_out <= '0';
                    coord_out <= (others => '0');
                    addr <= 513;
                    count <= 0;

                else 
                    case state is
                        when INIT =>
                            valid_out <= '0';
                            coord_out <= (others => '0');
                            state <= ADD;

                        when ADD =>
                            if count = 510 then
                                addr <= addr + 2;
                                count <= 0;
                            end if;
                            state <= WAITING;

                        when WAITING =>
                            if valid_next = '1' then
                                state <= OUTPUT;
                            end if;
                         
                        when OUTPUT =>
                            if flag = '0' then  
                                valid_out <= '1';
                                flag <= '1';
                                coord_out <= std_logic_vector(to_unsigned(addr, 19));
                            else 
                                addr <= addr + 1;
                                count <= count + 1;
                                valid_out <= '0';
                                flag <= '0';
                                state <= ADD;
                            end if;
                    end case;
                end if;
            end if;
        end process;
end Behavioral;

                         

                            
