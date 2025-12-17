library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_clock_prescaler is
end tb_clock_prescaler;

architecture Behavioral of tb_clock_prescaler is

    -- Declaración del componente (UUT)
    component clock_prescaler
        Port ( 
            clk_in   : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            clk_pwm  : out STD_LOGIC;
            clk_slow : out STD_LOGIC
        );
    end component;

    -- Señales de prueba
    signal s_clk_in   : std_logic := '0';
    signal s_rst      : std_logic := '0';
    signal s_clk_pwm  : std_logic;
    signal s_clk_slow : std_logic;

    -- Definición del periodo de reloj (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciación de la Unidad Bajo Prueba
    uut: clock_prescaler
        Port Map (
            clk_in   => s_clk_in,
            rst      => s_rst,
            clk_pwm  => s_clk_pwm,
            clk_slow => s_clk_slow
        );

    -- Proceso de generación de reloj de sistema
    p_clk: process
    begin
        s_clk_in <= '0';
        wait for CLK_PERIOD/2;
        s_clk_in <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Proceso de estímulos
    p_stim: process
    begin
        -- Activación inicial del reset
        s_rst <= '1';
        wait for 100 ns;
        
        -- Liberación del reset
        s_rst <= '0';

        -- La simulación continúa indefinidamente para observar
        -- la división de frecuencia en los contadores
        wait; 
    end process;

end Behavioral;