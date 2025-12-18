library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Port ( 
        CLK       : in  STD_LOGIC;
        BTN_IN    : in  STD_LOGIC;
        PULSE_OUT : out STD_LOGIC; -- Disparo de un ciclo (Flanco)
        BTN_STATE : out STD_LOGIC  -- Nivel estable (Nivel lógico)
    );
end Debouncer;

architecture Behavioral of Debouncer is
    -- Constante de filtrado: 10 ms @ 100 MHz
    constant C_DEBOUNCE_LIMIT : integer := 1_000_000;
    
    signal r_count      : integer range 0 to C_DEBOUNCE_LIMIT := 0;
    signal r_sync       : std_logic_vector(1 downto 0) := (others => '0');
    signal r_stable_val : std_logic := '0';
    signal r_prev_val   : std_logic := '0';
begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Sincronización de entrada (2 etapas)
            r_sync <= r_sync(0) & BTN_IN;

            -- Lógica de filtrado
            if (r_sync(1) /= r_stable_val) then
                r_count <= r_count + 1;
                if (r_count = C_DEBOUNCE_LIMIT) then
                    r_stable_val <= r_sync(1);
                    r_count <= 0;
                end if;
            else
                r_count <= 0;
            end if;

            -- Generación de pulso único (One-shot)
            if (r_stable_val = '1' and r_prev_val = '0') then
                PULSE_OUT <= '1';
            else
                PULSE_OUT <= '0';
            end if;
            
            r_prev_val <= r_stable_val;
        end if;
    end process;

    -- Salida de estado estable para la FSM
    BTN_STATE <= r_stable_val;

end Behavioral;