library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_line_buffer is
end tb_line_buffer;

architecture test of tb_line_buffer is
    constant WIDTH  : integer := 512;
    constant HEIGHT : integer := 512;
    constant DEPTH  : integer := 8;

    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal pixel_in      : std_logic_vector(DEPTH-1 downto 0);
    signal write_enable  : std_logic := '0';
    signal write_address : integer range 0 to WIDTH*HEIGHT - 1 := 0;

    component line_buffer
        generic (
            WIDTH : integer := 512;
            HEIGHT : integer := 512;
            DEPTH : integer := 8
        );
        port (
            clk           : in std_logic;
            reset         : in std_logic;
            pixel_in      : in std_logic_vector(DEPTH-1 downto 0);
            write_enable  : in std_logic;
            write_address : in integer range 0 to WIDTH*HEIGHT - 1
        );
    end component;
begin
    -- Instanciation du DUT
    uut : line_buffer
        generic map (
            WIDTH => WIDTH,
            HEIGHT => HEIGHT,
            DEPTH => DEPTH
        )
        port map (
            clk           => clk,
            reset         => reset,
            pixel_in      => pixel_in,
            write_enable  => write_enable,
            write_address => write_address
        );

    -- Clock process (50 MHz)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset actif
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Écrire 4 pixels aux adresses 0, 1, 2, 3
        for i in 0 to 3 loop
            pixel_in <= std_logic_vector(to_unsigned(i*15, DEPTH));
            write_address <= i;
            write_enable <= '1';
            wait for 20 ns;
        end loop;

        write_enable <= '0';

        wait for 100 ns;
        -- Fin simulation
        assert false report "Fin simulation" severity failure;
    end process;

end test;
