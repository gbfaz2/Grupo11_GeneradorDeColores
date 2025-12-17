library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Generador PWM usando genéricos
entity pwm_generator is
    Generic (
        G_WIDTH : integer := 8
    );
    Port ( 
        clk_pwm       : in  STD_LOGIC;
        rst           : in  STD_LOGIC;
        duty_cycle_in : in  STD_LOGIC_VECTOR (G_WIDTH-1 downto 0);
        pwm_out       : out STD_LOGIC
    );
end pwm_generator;

architecture Behavioral of pwm_generator is

    signal contador : unsigned(G_WIDTH-1 downto 0) := (others => '0');

begin

    -- Proceso del contador del PWM
    process (clk_pwm, rst)
    begin
        if rst = '1' then
            contador <= (others => '0');
        elsif rising_edge(clk_pwm) then
            contador <= contador + 1;
        end if;
    end process;

    -- Comparador para la salida
    pwm_out <= '1' when (contador < unsigned(duty_cycle_in)) else '0';

end Behavioral;