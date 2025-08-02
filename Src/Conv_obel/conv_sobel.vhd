-- ============================================================================
--  @brief      [FR] Ce bloc permet de réaliser une convolution de Sobel sur une image.
--
--  @details    [FR] Afin d'accélérer le traitement, une stratégie de calcul 
--                   est utilisée. Les données sont importées par groupes de 
--                   3 pixels de manière parallèle au calcul, afin d'éviter 
--                   toute attente. De plus, les données sont traitées par 
--                   groupes de trois et les résultats des calculs précédents 
--                   sont réutilisés pour accélérer le traitement. Il suffit 
--                   alors de changer le signe du résultat si nécessaire.
--
-- ============================================================================



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity conv_sobel is
    port (
        clk       : in  std_logic; -- Clock signal
        reset     : in  std_logic; -- Reset signal
        valid_in  : in  std_logic; -- Valid signal from previous stage
        pixel_in  : in  std_logic_vector(7 downto 0); -- Input pixel data (8 bits)
        valid_back : out std_logic; -- Valid signal for previous stage
        valid_out : out std_logic; -- Valid signal for output
        result_out : out std_logic_vector(7 downto 0) -- Check
    );
end conv_sobel;

architecture Behavioral of conv_sobel is

    signal buffer_0 : signed(10 downto 0) := (others => '0'); -- Buffer for result accumulation
    signal buffer_1 : signed(10 downto 0) := (others => '0'); -- Buffer for result accumulation
    signal buffer_2 : signed(10 downto 0) := (others => '0'); -- Buffer for result accumulation

    signal buffer_r1 : signed(10 downto 0) := (others => '0'); -- Buffer for result accumulation
    signal buffer_r2 : signed(10 downto 0) := (others => '0'); -- Buffer for result accumulation

    type sobel_matrix_type is array (0 to 2) of integer;
    constant matrice_sobel_truncate : sobel_matrix_type := (1, 2, 1);
    
    signal count_data_in : integer := 0;
    signal count_place_calculate : integer := 0;


begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                buffer <= (others => '0');
                valid_out <= '0';
                result_out <= (others => '0');
            elsif valid_in = '1' then
                if count_data_in = 0 then
                    if valid_in = '0' then

                    valid_back <= '1';
                
            



                