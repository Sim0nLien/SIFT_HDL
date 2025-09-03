use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity read_image is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        valid_in    : in std_logic;
        data_in     : in std_logic_vector(18 downto 0);
        valid_out   : out std_logic;
        data_out_1  : out std_logic_vector(8 downto 0);
        data_out_2  : out std_logic_vector(8 downto 0);
        data_out_3  : out std_logic_vector(8 downto 0)
    );
end read_image;

architecture Behavioral of read_image is
    type state_type is (INIT, WAITING, OUTPUT_1, OUTPUT_2, OUTPUT_3);
    signal state : state_type := INIT;

    signal addr_pix_1 : unsigned(18 downto 0);
    signal addr_pix_2 : unsigned(18 downto 0);
    signal addr_pix_3 : unsigned(18 downto 0);

    -- I don't know if that will be usefull but we never know

    signal data_pix_1 : unsigned(8 downto 0);
    signal data_pix_2 : unsigned(8 downto 0);
    signal data_pix_3 : unsigned(8 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= INIT;
                valid_out <= '0';
                addr_pix_1 <= (others => '0');
                addr_pix_2 <= (others => '0');
                addr_pix_3 <= (others => '0');
                data_pix_1 <= (others => '0');
                data_pix_2 <= (others => '0');
                data_pix_3 <= (others => '0');

            else
                case state is
                    when INIT =>
                        valid_out <= '0';
                        addr_pix_1 <= (others => '0');
                        addr_pix_2 <= (others => '0');
                        addr_pix_3 <= (others => '0');
                        data_pix_1 <= (others => '0');
                        data_pix_2 <= (others => '0');
                        data_pix_3 <= (others => '0');
                        state <= WAITING;

                    when WAITING =>
                        valid_out <= '0';
                        if valid_in = '1' then
                            





