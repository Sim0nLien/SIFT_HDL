library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_harris_response is
    port(
        clk                      : in std_logic;
        reset                    : in std_logic;
        valid_Ixx                : in std_logic;
        valid_Ixy                : in std_logic;
        valid_Iyy                : in std_logic;
        Ixx                      : in  STD_LOGIC_VECTOR(15 downto 0);
        Ixy                      : in  STD_LOGIC_VECTOR(15 downto 0);
        Iyy                      : in  STD_LOGIC_VECTOR(15 downto 0);
        valid_out                : out STD_LOGIC;
        out_result               : out STD_LOGIC_VECTOR(15 downto 0)
        );
end top_harris_response;

architecture Behavioral of top_harris_response is

    signal determinant : std_logic_vector(15 downto 0);
    signal trace       : std_logic_vector(15 downto 0);

    signal valid_det : std_logic;
    signal valid_tra : std_logic;

begin

    harris_trace_inst : entity work.harris_trace
        port map(
            clk        => clk,
            reset      => reset,
            valid_Ixx  => valid_Ixx,
            valid_Iyy  => valid_Iyy,
            Ixx        => Ixx,
            Iyy        => Iyy,
            valid_out  => valid_tra,
            trace      => trace
        );

    harris_determinant_inst : entity work.harris_determinant
        port map(
            clk        => clk,
            reset      => reset,
            valid_Ixx  => valid_Ixx,
            valid_Ixy  => valid_Ixy,
            valid_Iyy  => valid_Iyy,
            Ixx        => Ixx,
            Ixy        => Ixy,
            Iyy        => Iyy,
            valid_out  => valid_det,
            det        => determinant
        );

    harris_response_inst : entity work.harris_response
        port map(
            clk        => clk,
            reset      => reset,
            valid_det  => valid_det,
            valid_tra  => valid_tra,
            determinant => determinant,
            trace      => trace,
            valid_out  => valid_out,
            out_result => out_result
        );

end Behavioral;
