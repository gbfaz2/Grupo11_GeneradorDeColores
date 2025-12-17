library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Complementary_Calc is
    Port ( 
        -- Entradas: Los colores originales que eliges con los botones
        R_In : in  STD_LOGIC_VECTOR (7 downto 0);
        G_In : in  STD_LOGIC_VECTOR (7 downto 0);
        B_In : in  STD_LOGIC_VECTOR (7 downto 0);
        
        -- Salidas: Los colores invertidos para el segundo LED
        R_Out : out STD_LOGIC_VECTOR (7 downto 0);
        G_Out : out STD_LOGIC_VECTOR (7 downto 0);
        B_Out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end Complementary_Calc;

architecture Behavioral of Complementary_Calc is
begin
    -- Operación NOT: Invierte todos los bits (0->1, 1->0)
    -- Matemáticamente es igual a: 255 - Valor
    R_Out <= not R_In;
    G_Out <= not G_In;
    B_Out <= not B_In;
end Behavioral;