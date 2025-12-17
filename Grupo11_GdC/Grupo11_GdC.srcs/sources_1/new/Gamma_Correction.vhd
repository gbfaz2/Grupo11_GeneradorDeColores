library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gamma_Correction is
    Port ( 
        Input_Val  : in  STD_LOGIC_VECTOR (7 downto 0); -- Valor matemático (0-255)
        Output_Val : out STD_LOGIC_VECTOR (7 downto 0)  -- Valor ajustado al ojo (0-255)
    );
end Gamma_Correction;

architecture Behavioral of Gamma_Correction is
    -- Definimos la memoria ROM para guardar la tabla
    type rom_type is array (0 to 255) of std_logic_vector(7 downto 0);
    
    -- TABLA GAMMA 2.2 (Estándar industrial para vídeo)
    constant GAMMA_ROM : rom_type := (
        X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"01", -- 0-7
        X"01", X"01", X"01", X"01", X"01", X"01", X"01", X"01", -- 8-15
        X"01", X"01", X"02", X"02", X"02", X"02", X"02", X"02", -- 16-23
        X"02", X"03", X"03", X"03", X"03", X"04", X"04", X"04", -- 24-31
        X"04", X"05", X"05", X"05", X"06", X"06", X"07", X"07", -- 32-39
        X"08", X"08", X"09", X"09", X"0A", X"0A", X"0B", X"0C", -- 40-47
        X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"11", X"12", -- 48-55
        X"13", X"14", X"15", X"16", X"17", X"18", X"19", X"1B", -- 56-63
        X"1C", X"1D", X"1E", X"20", X"21", X"22", X"24", X"25", -- 64-71
        X"26", X"28", X"29", X"2B", X"2C", X"2E", X"30", X"31", -- 72-79
        X"33", X"35", X"37", X"38", X"3A", X"3C", X"3E", X"40", -- 80-87
        X"42", X"44", X"46", X"48", X"4B", X"4D", X"4F", X"52", -- 88-95
        X"54", X"57", X"59", X"5C", X"5F", X"61", X"64", X"67", -- 96-103
        X"6A", X"6D", X"70", X"73", X"76", X"79", X"7C", X"80", -- 104-111
        X"83", X"87", X"8A", X"8E", X"92", X"95", X"99", X"9D", -- 112-119
        X"A1", X"A5", X"A9", X"AD", X"B1", X"B6", X"BA", X"BF", -- 120-127
        X"C3", X"C8", X"CC", X"D1", X"D6", X"DB", X"E0", X"E5", -- 128-135
        X"EA", X"EF", X"F4", X"FA", X"FF", X"FF", X"FF", X"FF", -- 136-143
        -- Rellenamos el resto con FF 
        others => X"FF"
    );
begin
    Output_Val <= GAMMA_ROM(to_integer(unsigned(Input_Val)));
end Behavioral;