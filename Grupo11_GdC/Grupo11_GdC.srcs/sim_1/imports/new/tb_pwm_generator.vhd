library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_pwm_generator is
end tb_pwm_generator;

architecture Behavioral of tb_pwm_generator is

    -- Declaración del componente a probar (UUT)
    component pwm_generator
        Generic ( G_WIDTH : integer := 8 );
        Port ( 
            clk_pwm       : in STD_LOGIC;
            rst           : in STD_LOGIC;
            duty_cycle_in : in STD_LOGIC_VECTOR (7 downto 0);
            pwm_out       : out STD_LOGIC
        );
    end component;

    -- Entradas
    signal clk_tb  : std_logic := '0';
    signal rst_tb  : std_logic := '0';
    signal duty_tb : std_logic_vector(7 downto 0) := (others => '0');

    -- Salidas
    signal pwm_out_tb : std_logic;

    -- Definición del periodo de reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciación de la Unidad Bajo Prueba (UUT)
    uut: pwm_generator
        Generic Map ( G_WIDTH => 8 )
        Port Map (
            clk_pwm       => clk_tb,
            rst           => rst_tb,
            duty_cycle_in => duty_tb,
            pwm_out       => pwm_out_tb
        );

    -- Proceso de generación de reloj
    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD/2;
        clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Proceso de estímulos
    stim_proc: process
    begin		
        -- Estado de reset inicial
        rst_tb <= '1';
        duty_tb <= (others => '0');
        wait for 100 ns;	
        
        rst_tb <= '0';
        wait for CLK_PERIOD;

        -- Caso 1: Ciclo de trabajo 0%
        duty_tb <= "00000000"; 
        wait for 2 ms;

        -- Caso 2: Ciclo de trabajo ~50%
        duty_tb <= "10000000"; -- 128 decimal
        wait for 2 ms;

        -- Caso 3: Ciclo de trabajo 100% (Brillo máx)
        duty_tb <= "11111111"; -- 255 decimal
        wait for 2 ms;

        wait;
    end process;

end Behavioral;