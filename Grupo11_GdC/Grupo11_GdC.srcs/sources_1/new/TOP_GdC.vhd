LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.PKG_RGB_TYPES.ALL; 

ENTITY TOP_GdC IS
    PORT ( 
        CLK100MHZ : IN  STD_LOGIC;
        CPU_RESETN: IN  STD_LOGIC; 
        
        -- Entradas usuario
        BTNU      : IN  STD_LOGIC; 
        BTND      : IN  STD_LOGIC; 
        SW        : IN  STD_LOGIC_VECTOR (3 DOWNTO 0); 
        
        -- Salidas LED 16 (Original)
        LED16_R   : OUT STD_LOGIC; 
        LED16_G   : OUT STD_LOGIC; 
        LED16_B   : OUT STD_LOGIC;

        -- Salidas LED 17 (Complementario)
        LED17_R   : OUT STD_LOGIC; 
        LED17_G   : OUT STD_LOGIC; 
        LED17_B   : OUT STD_LOGIC
    );
END TOP_GdC;

ARCHITECTURE BEHAVIORAL OF TOP_GdC IS

    -- Senales globales
    signal s_rst     : std_logic;
    signal s_clk_pwm : std_logic; 
    
    -- Interfaz botones
    signal s_up_pulse, s_up_state     : std_logic;
    signal s_down_pulse, s_down_state : std_logic;

    -- Datos RGB
    signal s_rgb_data : T_COLORES_RGB;

    -- Datos Complementarios
    signal s_comp_r, s_comp_g, s_comp_b : std_logic_vector(7 downto 0);

    -- Senales Gamma
    signal s_rojo_gamma, s_verde_gamma, s_azul_gamma : std_logic_vector(7 downto 0);
    signal s_comp_gamma_r, s_comp_gamma_g, s_comp_gamma_b : std_logic_vector(7 downto 0);

BEGIN

    s_rst <= NOT CPU_RESETN; 

    -- Prescaler
    Inst_Prescaler: entity work.clock_prescaler
    Port Map( clk_in => CLK100MHZ, rst => s_rst, clk_pwm => s_clk_pwm, clk_slow => open );

    -- Debouncers
    Inst_Deb_Up: entity work.Debouncer
    Port Map( CLK => CLK100MHZ, BTN_IN => BTNU, PULSE_OUT => s_up_pulse, BTN_STATE => s_up_state );

    Inst_Deb_Down: entity work.Debouncer
    Port Map( CLK => CLK100MHZ, BTN_IN => BTND, PULSE_OUT => s_down_pulse, BTN_STATE => s_down_state );

    -- Controlador Principal
    Inst_Controlador: entity work.RGB_CONTROLADOR
    Port Map(
        CLK_RGB        => CLK100MHZ,
        RST_RGB        => s_rst,
        BTN_UP_PULSE   => s_up_pulse,
        BTN_UP_STATE   => s_up_state,
        BTN_DOWN_PULSE => s_down_pulse,
        BTN_DOWN_STATE => s_down_state,
        SW_RGB         => SW,
        VALOR_SALIDA   => s_rgb_data
    );

    -- Modulo Complementario
    Inst_Complementario: entity work.Complementary_Calc
    Port Map(
        R_In  => s_rgb_data.ROJO,
        G_In  => s_rgb_data.VERDE,
        B_In  => s_rgb_data.AZUL,
        R_Out => s_comp_r,
        G_Out => s_comp_g,
        B_Out => s_comp_b
    );

    -- Gamma Original
    Inst_G_R: entity work.Gamma_Correction Port Map(Input_Val => s_rgb_data.ROJO,  Output_Val => s_rojo_gamma);
    Inst_G_G: entity work.Gamma_Correction Port Map(Input_Val => s_rgb_data.VERDE, Output_Val => s_verde_gamma);
    Inst_G_B: entity work.Gamma_Correction Port Map(Input_Val => s_rgb_data.AZUL,  Output_Val => s_azul_gamma);
    
    -- Gamma Complementario
    Inst_G_Comp_R: entity work.Gamma_Correction Port Map(Input_Val => s_comp_r, Output_Val => s_comp_gamma_r);
    Inst_G_Comp_G: entity work.Gamma_Correction Port Map(Input_Val => s_comp_g, Output_Val => s_comp_gamma_g);
    Inst_G_Comp_B: entity work.Gamma_Correction Port Map(Input_Val => s_comp_b, Output_Val => s_comp_gamma_b);

    -- PWM LED 16 (Original)
    Inst_PWM_R: entity work.PWM_SSDM_LFSR Generic Map(G_WIDTH => 8) Port Map(CLK_PWM => s_clk_pwm, RST => s_rst, DUTY_CYCLE_IN => s_rojo_gamma, PWM_OUT => LED16_R);
    Inst_PWM_G: entity work.PWM_SSDM_LFSR Generic Map(G_WIDTH => 8) Port Map(CLK_PWM => s_clk_pwm, RST => s_rst, DUTY_CYCLE_IN => s_verde_gamma, PWM_OUT => LED16_G);
    Inst_PWM_B: entity work.PWM_SSDM_LFSR Generic Map(G_WIDTH => 8) Port Map(CLK_PWM => s_clk_pwm, RST => s_rst, DUTY_CYCLE_IN => s_azul_gamma, PWM_OUT => LED16_B);
    
    -- PWM LED 17 (Complementario)
    Inst_PWM_CR: entity work.PWM_SSDM_LFSR Generic Map(G_WIDTH => 8) Port Map(CLK_PWM => s_clk_pwm, RST => s_rst, DUTY_CYCLE_IN => s_comp_gamma_r, PWM_OUT => LED17_R);
    Inst_PWM_CG: entity work.PWM_SSDM_LFSR Generic Map(G_WIDTH => 8) Port Map(CLK_PWM => s_clk_pwm, RST => s_rst, DUTY_CYCLE_IN => s_comp_gamma_g, PWM_OUT => LED17_G);
    Inst_PWM_CB: entity work.PWM_SSDM_LFSR Generic Map(G_WIDTH => 8) Port Map(CLK_PWM => s_clk_pwm, RST => s_rst, DUTY_CYCLE_IN => s_comp_gamma_b, PWM_OUT => LED17_B);

END BEHAVIORAL;