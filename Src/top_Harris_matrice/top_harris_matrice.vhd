library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_harris_matrice is
    port(
        clk                      : in std_logic;
        reset                    : in std_logic;
        valid_in_manager         : in std_logic;
        valid_in_Ix              : in std_logic;
        valid_in_Iy              : in std_logic;
        Ix1                      : in std_logic_vector(12 downto 0);
        Ix2                      : in std_logic_vector(12 downto 0);
        Ix3                      : in std_logic_vector(12 downto 0);
        Iy1                      : in std_logic_vector(12 downto 0);
        Iy2                      : in std_logic_vector(12 downto 0);
        Iy3                      : in std_logic_vector(12 downto 0);
        coord_out                : out std_logic_vector(18 downto 0);
        valid_manager            : out std_logic;
        valid_gaussian_conv_Ixx  : out std_logic;
        valid_gaussian_conv_Ixy  : out std_logic;
        valid_gaussian_conv_Iyy  : out std_logic;
        res_XX                   : out std_logic_vector(15 downto 0);
        res_XY                   : out std_logic_vector(15 downto 0);
        res_YY                   : out std_logic_vector(15 downto 0)
    );
end top_harris_matrice;

architecture Behavioral of top_harris_matrice is

    signal valid_derivate_Ixx : std_logic;
    signal valid_derivate_Ixy : std_logic;
    signal valid_derivate_Iyy : std_logic;

    signal Ixx1, Ixx2, Ixx3 : std_logic_vector(15 downto 0);
    signal Ixy1, Ixy2, Ixy3 : std_logic_vector(15 downto 0);
    signal Iyy1, Iyy2, Iyy3 : std_logic_vector(15 downto 0);

begin

    harris_matrice_manager_inst : entity work.harris_matrice_manager
    port map(
        clk         => clk,
        reset       => reset,
        valid_next  => valid_in_manager,
        coord_out   => coord_out,
        valid_out   => valid_manager
    );

    derivate_Ixx_inst : entity work.derivate_Ixx
    port map(
        clk         => clk,
        reset       => reset,
        valid_in    => valid_in_Ix,
        Ix1         => Ix1,
        Ix2         => Ix2,
        Ix3         => Ix3,
        valid_out   => valid_derivate_Ixx,
        Ixx1        => Ixx1,
        Ixx2        => Ixx2,
        Ixx3        => Ixx3
    );

    derivate_Ixy_inst : entity work.derivate_Ixy
    port map(
        clk         => clk,
        reset       => reset,
        valid_in_x  => valid_in_Ix,
        valid_in_y  => valid_in_Iy,
        Ix1         => Ix1,
        Ix2         => Ix2,
        Ix3         => Ix3,
        Iy1         => Iy1,
        Iy2         => Iy2,
        Iy3         => Iy3,
        valid_out   => valid_derivate_Ixy,
        Ixy1        => Ixy1,
        Ixy2        => Ixy2,
        Ixy3        => Ixy3
    );

    derivate_Iyy_inst : entity work.derivate_Iyy
    port map(
        clk         => clk,
        reset       => reset,
        valid_in    => valid_in_Iy,
        Iy1         => Iy1,
        Iy2         => Iy2,
        Iy3         => Iy3,
        valid_out   => valid_derivate_Iyy,
        Iyy1        => Iyy1,
        Iyy2        => Iyy2,
        Iyy3        => Iyy3
    );

    gaussian_conv_Ixx : entity work.gaussian_conv
    port map(
        clk         => clk,
        reset       => reset,
        valid_in    => valid_derivate_Ixx,
        I1         => Ixx1,
        I2         => Ixx2,
        I3         => Ixx3,
        valid_out   => valid_gaussian_conv_Ixx,
        res         => res_XX
    );

    gaussian_conv_Ixy : entity work.gaussian_conv
    port map(
        clk         => clk,
        reset       => reset,
        valid_in    => valid_derivate_Ixy,
        I1         => Ixy1,
        I2         => Ixy2,
        I3         => Ixy3,
        valid_out   => valid_gaussian_conv_Ixy,
        res         => res_XY
    );

    gaussian_conv_Iyy : entity work.gaussian_conv
    port map(
        clk         => clk,
        reset       => reset,
        valid_in    => valid_derivate_Iyy,
        I1         => Iyy1,
        I2         => Iyy2,
        I3         => Iyy3,
        valid_out   => valid_gaussian_conv_Iyy,
        res         => res_YY
    );

end Behavioral;