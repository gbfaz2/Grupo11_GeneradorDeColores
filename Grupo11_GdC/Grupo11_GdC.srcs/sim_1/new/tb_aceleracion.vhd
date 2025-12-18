LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.PKG_RGB_TYPES.ALL; 

ENTITY tb_aceleracion IS
END tb_aceleracion;

ARCHITECTURE Behavior OF tb_aceleracion IS

    -- Declaracion del componente (UUT)
    COMPONENT RGB_CONTROLADOR
    PORT(
        CLK_RGB        : IN  std_logic;
        RST_RGB        : IN  std_logic;
        BTN_UP_PULSE   : IN  std_logic;
        BTN_UP_STATE   : IN  std_logic;
        BTN_DOWN_PULSE : IN  std_logic;
        BTN_DOWN_STATE : IN  std_logic;
        SW_RGB         : IN  std_logic_vector(3 downto 0);
        VALOR_SALIDA   : OUT T_COLORES_RGB
    );
    END COMPONENT;
    
    -- Señales de interconexion
    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';
    
    -- Simulacion de entradas de usuario
    signal s_btn_up_pulse   : std_logic := '0';
    signal s_btn_up_state   : std_logic := '0';
    signal s_btn_down_pulse : std_logic := '0';
    signal s_btn_down_state : std_logic := '0';
    
    signal s_sw : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Salida observada
    signal s_salida : T_COLORES_RGB;

    -- Definicion de periodo de reloj (100 MHz)
    constant C_CLK_PERIOD : time := 10 ns;

BEGIN

    -- Instancia Unit Under Test
    uut: RGB_CONTROLADOR PORT MAP (
        CLK_RGB        => s_clk,
        RST_RGB        => s_rst,
        BTN_UP_PULSE   => s_btn_up_pulse,
        BTN_UP_STATE   => s_btn_up_state,
        BTN_DOWN_PULSE => s_btn_down_pulse,
        BTN_DOWN_STATE => s_btn_down_state,
        SW_RGB         => s_sw,
        VALOR_SALIDA   => s_salida
    );

    -- Generacion de reloj del sistema
    p_clk: process
    begin
        s_clk <= '0';
        wait for C_CLK_PERIOD/2;
        s_clk <= '1';
        wait for C_CLK_PERIOD/2;
    end process;

    -- Proceso de estimulos
    p_stim: process
    begin		
        -- Inicializacion y Reset
        s_rst <= '1';
        s_sw <= (others => '0');
        wait for 40 ns;	
        s_rst <= '0';
        wait for 20 ns;

        -- Seleccion de canal ROJO (Bit 2 activo)
        s_sw <= "0100"; 
        wait for 20 ns;

        -- CASO 1: Pulsacion corta (Incremento unitario)
        s_btn_up_pulse <= '1';
        s_btn_up_state <= '1'; 
        wait for C_CLK_PERIOD; -- 1 ciclo de pulso
        
        s_btn_up_pulse <= '0';
        wait for 5 * C_CLK_PERIOD; -- Soltar rapido
        s_btn_up_state <= '0';
        
        wait for 50 ns;

        -- CASO 2: Pulsacion larga (Activacion Turbo)
        -- Nota: Verificar constantes de tiempo en RTL para simulacion
        s_btn_up_pulse <= '1';
        s_btn_up_state <= '1'; 
        wait for C_CLK_PERIOD; 
        
        s_btn_up_pulse <= '0';
        
        -- Mantener estado alto para forzar modo acelerado
        wait for 300 * C_CLK_PERIOD; 

        -- Soltar boton
        s_btn_up_state <= '0';
        wait for 50 ns;
        
        -- CASO 3: Bajada rapida
        s_btn_down_pulse <= '1';
        s_btn_down_state <= '1';
        wait for C_CLK_PERIOD;
        
        s_btn_down_pulse <= '0';
        wait for 150 * C_CLK_PERIOD;
        
        s_btn_down_state <= '0';

        wait;
    end process;

END Behavior;