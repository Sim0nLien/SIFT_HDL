library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mem_3x3 is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in std_logic;
        data_in     : in std_logic_vector(8 downto 0);
        addr_in     : in std_logic_vector(18 downto 0);
        call_out_1  : out std_logic;
        call_out_2  : out std_logic;
        call_out_3  : out std_logic;
        valid_out_1 : out std_logic; -- A check si j'en ai besoin de 3 et pas simplement 1
        valid_out_2 : out std_logic;
        valid_out_3 : out std_logic;
        data_out_1  : out std_logic_vector(8 downto 0);
        data_out_2  : out std_logic_vector(8 downto 0);
        data_out_3  : out std_logic_vector(8 downto 0);
        addr_out_1  : out std_logic_vector(18 downto 0);
        addr_out_2  : out std_logic_vector(18 downto 0);
        addr_out_3  : out std_logic_vector(18 downto 0)
    );
end entity mem_3x3;

architecture Behavioral of mem_3x3 is

    
    type memory_data is array (0 to 8) of std_logic_vector(8 downto 0);
    signal mem_data : mem_data := (others => (others => '0'));
    
    -- Because we are just working with the exact addr 

    signal addr_reg : std_logic_vector(18 downto 0) := (others => '0');

    signal count : integer range 0 to 8 := 0;

begin
    process(clk)

    begin
        if rising_edge(clk) then
            if reset = '1' then
                memory <= (others => (others => '0'));
                call_out_1 <= '0';
                call_out_2 <= '0';
                call_out_3 <= '0';
                valid_out_1 <= '0';
                valid_out_2 <= '0';
                valid_out_3 <= '0';
                data_out_1 <= (others => '0');
                data_out_2 <= (others => '0');
                data_out_3 <= (others => '0');
                addr_out_1 <= (others => '0');
                addr_out_2 <= (others => '0');
                addr_out_3 <= (others => '0');
                count <= 0;
            
            else
                if valid_in = '1' then
                    memory(count) <= data_in
                    addr_reg <= addr_in;
                    if count == 8 then
                        count <= 0


                 


            
                    








    end process;
end Behavioral;