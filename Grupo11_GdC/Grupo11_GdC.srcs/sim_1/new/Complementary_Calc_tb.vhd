LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Complementary_Calc_tb IS
END Complementary_Calc_tb;
 
ARCHITECTURE behavior OF Complementary_Calc_tb IS 
 
    -- 1. Declaración del Componente (Debe coincidir con TU código)
    COMPONENT Complementary_Calc
    PORT(
         R_In : IN  std_logic_vector(7 downto 0);
         G_In : IN  std_logic_vector(7 downto 0);
         B_In : IN  std_logic_vector(7 downto 0);
         R_Out : OUT  std_logic_vector(7 downto 0);
         G_Out : OUT  std_logic_vector(7 downto 0);
         B_Out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
    -- 2. Señales para conectar al componente
    signal s_R_In : std_logic_vector(7 downto 0) := (others => '0');
    signal s_G_In : std_logic_vector(7 downto 0) := (others => '0');
    signal s_B_In : std_logic_vector(7 downto 0) := (others => '0');

    signal s_R_Out : std_logic_vector(7 downto 0);
    signal s_G_Out : std_logic_vector(7 downto 0);
    signal s_B_Out : std_logic_vector(7 downto 0);
 
BEGIN
 
    -- 3. Instanciación (Unit Under Test)
    uut: Complementary_Calc PORT MAP (
          R_In => s_R_In,
          G_In => s_G_In,
          B_In => s_B_In,
          R_Out => s_R_Out,
          G_Out => s_G_Out,
          B_Out => s_B_Out
        );

    -- 4. Proceso de Estímulos
    stim_proc: process
    begin		
        -- Espera inicial
        wait for 100 ns;	

        -- CASO 1: Entrada NEGRO (00,00,00) -> Salida debe ser BLANCO (FF,FF,FF)
        s_R_In <= x"00"; s_G_In <= x"00"; s_B_In <= x"00";
        wait for 50 ns;

        -- CASO 2: Entrada BLANCO (FF,FF,FF) -> Salida debe ser NEGRO (00,00,00)
        s_R_In <= x"FF"; s_G_In <= x"FF"; s_B_In <= x"FF";
        wait for 50 ns;

        -- CASO 3: Entrada ROJO (FF,00,00) -> Salida debe ser CIAN (00,FF,FF)
        s_R_In <= x"FF"; s_G_In <= x"00"; s_B_In <= x"00";
        wait for 50 ns;

        -- CASO 4: Entrada VERDE (00,FF,00) -> Salida debe ser MAGENTA (FF,00,FF)
        s_R_In <= x"00"; s_G_In <= x"FF"; s_B_In <= x"00";
        wait for 50 ns;

        -- CASO 5: Entrada AZUL (00,00,FF) -> Salida debe ser AMARILLO (FF,FF,00)
        s_R_In <= x"00"; s_G_In <= x"00"; s_B_In <= x"FF";
        wait for 50 ns;

        wait; -- Fin de la prueba
    end process;

END;