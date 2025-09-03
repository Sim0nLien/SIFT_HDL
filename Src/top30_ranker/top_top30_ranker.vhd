library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_top30_ranker is
    generic(
        DATA_WIDTH : integer := 16;
        ADDR_WIDTH : integer := 18;
        NB_DATA    : integer := 32
        );
    port(
        clk            : in STD_LOGIC;
        reset          : in STD_LOGIC;
        valid_in       : in STD_LOGIC;
        data_in        : in STD_LOGIC_VECTOR(15 downto 0);
        addr_in        : in STD_LOGIC_VECTOR(17 downto 0);
        give_data      : in STD_LOGIC;
        end_comparing  : out STD_LOGIC;
        addr_out       : out STD_LOGIC_VECTOR(17 downto 0); -- To check
        all_addrs      : out STD_LOGIC_VECTOR((NB_DATA*ADDR_WIDTH)-1 downto 0)
    );
end top_top30_ranker;

architecture Behavioral of top_top30_ranker is

    signal threshold : STD_LOGIC_VECTOR(15 downto 0);
    signal valid_threshold : STD_LOGIC := '0';

    signal data_rank2sorter : STD_LOGIC_VECTOR(15 downto 0);
    signal valid_rank2sorter : STD_LOGIC := '0';

begin 
    
    ranking_threshold_inst: entity work.ranking_threshold
        port map(
            clk => clk, --
            reset => reset,
            valid_in => valid_in,
            valid_threshold => valid_threshold,
            data_in => data_in,
            threshold => threshold,
            end_comparing => end_comparing,
            valid_out => valid_rank2sorter,
            data_out => data_rank2sorter
        );


    top30_sorter_inst : entity work.top30_sorter
        port map(
            clk => clk,
            reset => reset,
            valid_in => valid_rank2sorter,
            data_in => data_rank2sorter,
            addr_in => addr_in,
            give_data => give_data,
            valid_out => valid_threshold,
            data_out => threshold,
            addr_out => addr_out,
            all_addrs => all_addrs
        );


end Behavioral;





