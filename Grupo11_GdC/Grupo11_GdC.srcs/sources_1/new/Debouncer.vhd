library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Port ( 
        CLK       : in  STD_LOGIC; -- Reloj de 100 MHz
        BTN_IN    : in  STD_LOGIC; -- Botón ruidoso de la placa
        PULSE_OUT : out STD_LOGIC  -- Pulso limpio de un ciclo de reloj
    );
end Debouncer;

architecture Behavioral of Debouncer is
    -- Constantes para el temporizador (suponiendo reloj 100MHz)
    -- 10 ms de espera suele ser suficiente para eliminar rebotes
    constant TIMEOUT : integer := 1000000; 
    signal counter   : integer range 0 to TIMEOUT := 0;
    signal sync_0    : std_logic := '0';
    signal sync_1    : std_logic := '0';
    signal btn_stable: std_logic := '0';
    signal btn_prev  : std_logic := '0';
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            -- 1. Sincronización (doble flip-flop) para evitar metaestabilidad
            sync_0 <= BTN_IN;
            sync_1 <= sync_0;

            -- 2. Filtro de rebotes
            if (sync_1 /= btn_stable) then
                counter <= counter + 1;
                if (counter = TIMEOUT) then
                    btn_stable <= sync_1;
                    counter <= 0;
                end if;
            else
                counter <= 0;
            end if;

            -- 3. Generación de pulso (One-shot)
            -- Solo genera un '1' durante un ciclo cuando el botón pasa de 0 a 1
            if (btn_stable = '1' and btn_prev = '0') then
                PULSE_OUT <= '1';
            else
                PULSE_OUT <= '0';
            end if;
            btn_prev <= btn_stable;
        end if;
    end process;
end Behavioral;
