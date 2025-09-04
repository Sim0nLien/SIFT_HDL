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
        valid_out_1 : out std_logic; -- A check si j'en ai besoin de 3 et pas simplement 1
        call_out_1  : out std_logic;
        call_out_2  : out std_logic;
        call_out_3  : out std_logic;
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

    ty



