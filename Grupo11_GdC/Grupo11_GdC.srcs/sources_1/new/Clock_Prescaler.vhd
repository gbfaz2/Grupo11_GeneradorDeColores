library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modulo Prescaler
-- Genera relojes de menor frecuencia a partir del reloj base de 100 MHz de la FPGA
entity clock_prescaler is
    Port ( 
        clk_in   : in  STD_LOGIC; -- Reloj entrada (100 MHz)
        rst      : in  STD_LOGIC;
        clk_pwm  : out STD_LOGIC; -- Salida rápida para PWM
        clk_slow : out STD_LOGIC  -- Salida lenta para control visual/debounce
    );
end clock_prescaler;

architecture Behavioral of clock_prescaler is

    -- Constantes de division de frecuencia
    -- Formula: Cuentas = F_in / (2 * F_out)
    
    -- Objetivo: 100 kHz -> 100 MHz / 200 kHz = 500
    constant C_LIMIT_PWM  : integer := 500; 
    
    -- Objetivo: 100 Hz -> 100 MHz / 200 Hz = 500.000
    constant C_LIMIT_SLOW : integer := 500000;

    -- Contadores y registros de salida
    signal r_cnt_pwm  : integer range 0 to C_LIMIT_PWM := 0;
    signal r_clk_pwm  : std_logic := '0';

    signal r_cnt_slow : integer range 0 to C_LIMIT_SLOW := 0;
    signal r_clk_slow : std_logic := '0';

begin

    -- Divisor para reloj PWM (100 kHz)
    process(clk_in, rst)
    begin
        if rst = '1' then
            r_cnt_pwm <= 0;
            r_clk_pwm <= '0';
        elsif rising_edge(clk_in) then
            -- Si llegamos al tope, reiniciamos cuenta y conmutamos salida
            if r_cnt_pwm = (C_LIMIT_PWM - 1) then
                r_cnt_pwm <= 0;
                r_clk_pwm <= not r_clk_pwm;
            else
                r_cnt_pwm <= r_cnt_pwm + 1;
            end if;
        end if;
    end process;

    -- Divisor para reloj lento (100 Hz)
    process(clk_in, rst)
    begin
        if rst = '1' then
            r_cnt_slow <= 0;
            r_clk_slow <= '0';
        elsif rising_edge(clk_in) then
            if r_cnt_slow = (C_LIMIT_SLOW - 1) then
                r_cnt_slow <= 0;
                r_clk_slow <= not r_clk_slow; -- Toggle
            else
                r_cnt_slow <= r_cnt_slow + 1;
            end if;
        end if;
    end process;

    -- Asignacion a puertos de salida
    clk_pwm  <= r_clk_pwm;
    clk_slow <= r_clk_slow;

end Behavioral;