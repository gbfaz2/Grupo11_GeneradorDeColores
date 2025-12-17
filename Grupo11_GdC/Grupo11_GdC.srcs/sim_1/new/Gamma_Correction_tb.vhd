library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Necesario para poder contar en el bucle

entity Gamma_Correction_tb is
-- Entidad vacía para el testbench
end Gamma_Correction_tb;

architecture Behavior of Gamma_Correction_tb is

    -- 1. Declaramos el componente (Tu módulo)
    component Gamma_Correction
        Port ( 
            Input_Val  : in  STD_LOGIC_VECTOR (7 downto 0);
            Output_Val : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- 2. Señales para conectar
    signal Input_Val  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal Output_Val : STD_LOGIC_VECTOR (7 downto 0);

begin

    -- 3. Conectamos el módulo (UUT - Unit Under Test)
    uut: Gamma_Correction PORT MAP (
        Input_Val => Input_Val,
        Output_Val => Output_Val
    );

    -- 4. Proceso de Estímulos (Aquí no hace falta reloj porque es lógica combinacional)
    stim_proc: process
    begin
        -- Esperamos un poco al principio
        wait for 100 ns;

        -- PRUEBA 1: Puntos clave manuales
        -- Probamos el 0 (Debería salir 00)
        Input_Val <= x"00"; 
        wait for 10 ns;
        
        -- Probamos el valor 40 decimal (x28) -> Según tu tabla debería salir 08
        Input_Val <= std_logic_vector(to_unsigned(40, 8)); 
        wait for 10 ns;

        -- PRUEBA 2: BARRIDO COMPLETO (0 a 255)
        -- Esto generará una rampa perfecta en la entrada para ver la curva en la salida
        for i in 0 to 255 loop
            Input_Val <= std_logic_vector(to_unsigned(i, 8));
            wait for 10 ns; -- Esperamos 10ns entre cada prueba
        end loop;

        -- Fin de la prueba
        wait;
    end process;

end Behavior;