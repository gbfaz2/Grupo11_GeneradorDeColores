LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Definicion de tipos para bus RGB
PACKAGE PKG_RGB_TYPES IS
    TYPE T_COLORES_RGB IS RECORD
        ROJO  : STD_LOGIC_VECTOR(7 DOWNTO 0); 
        VERDE : STD_LOGIC_VECTOR(7 DOWNTO 0); 
        AZUL  : STD_LOGIC_VECTOR(7 DOWNTO 0); 
    END RECORD;
END PACKAGE PKG_RGB_TYPES;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PKG_RGB_TYPES.ALL;

ENTITY RGB_CONTROLADOR IS
    PORT (
        CLK_RGB : IN  STD_LOGIC;
        RST_RGB : IN  STD_LOGIC;
        
        -- Control de botones (Pulso y Nivel)
        BTN_UP_PULSE   : IN  STD_LOGIC; 
        BTN_UP_STATE   : IN  STD_LOGIC; 
        BTN_DOWN_PULSE : IN  STD_LOGIC;
        BTN_DOWN_STATE : IN  STD_LOGIC;
        
        SW_RGB : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        
        VALOR_SALIDA : OUT T_COLORES_RGB
    );
END RGB_CONTROLADOR;

ARCHITECTURE BEHAVIORAL OF RGB_CONTROLADOR IS

    -- Estados de la FSM de aceleracion
    TYPE t_fsm_state IS (ST_IDLE, ST_WAIT, ST_TURBO);
    
    signal s_state_up   : t_fsm_state;
    signal s_state_down : t_fsm_state;

    -- Temporizacion (Fclk = 100 MHz)
    constant C_DELAY_WAIT  : integer :=50_000_000; -- 0.5s inicio            ////Para testbech de aceleración se usa 20
    constant C_DELAY_TURBO : integer := 5; --5_000_000;  -- 0.05s repeticion ////Para testbench de aceleración se usa 5

    -- Registros internos
    signal r_rojo  : unsigned(7 downto 0) := (others => '0');
    signal r_verde : unsigned(7 downto 0) := (others => '0');
    signal r_azul  : unsigned(7 downto 0) := (others => '0');

    signal r_timer_up   : integer range 0 to C_DELAY_WAIT := 0;
    signal r_timer_down : integer range 0 to C_DELAY_WAIT := 0;

BEGIN

    PROCESS (CLK_RGB, RST_RGB)
    BEGIN
        IF RST_RGB = '1' THEN 
            r_rojo   <= (others => '0');
            r_verde  <= (others => '0');
            r_azul   <= (others => '0');
            s_state_up   <= ST_IDLE;
            s_state_down <= ST_IDLE;
            r_timer_up   <= 0;
            r_timer_down <= 0;
            
        ELSIF RISING_EDGE(CLK_RGB) THEN
            
            -----------------------------------------------------------
            -- FSM Incremento (UP)
            -----------------------------------------------------------
            CASE s_state_up IS
                
                WHEN ST_IDLE =>
                    r_timer_up <= 0;
                    if BTN_UP_PULSE = '1' then
                        -- Incremento inicial
                        IF SW_RGB(2)='1' AND r_rojo<255 THEN r_rojo <= r_rojo + 1; END IF;
                        IF SW_RGB(1)='1' AND r_verde<255 THEN r_verde <= r_verde + 1; END IF;
                        IF SW_RGB(0)='1' AND r_azul<255 THEN r_azul <= r_azul + 1; END IF;
                        
                        s_state_up <= ST_WAIT;
                    end if;

                WHEN ST_WAIT =>
                    if BTN_UP_STATE = '0' then
                        s_state_up <= ST_IDLE;
                    else
                        if r_timer_up < C_DELAY_WAIT then
                            r_timer_up <= r_timer_up + 1;
                        else
                            r_timer_up <= 0;
                            s_state_up <= ST_TURBO;
                        end if;
                    end if;

                WHEN ST_TURBO =>
                    if BTN_UP_STATE = '0' then
                        s_state_up <= ST_IDLE;
                    else
                        if r_timer_up < C_DELAY_TURBO then
                            r_timer_up <= r_timer_up + 1;
                        else
                            r_timer_up <= 0;
                            -- Incremento ciclico
                            IF SW_RGB(2)='1' AND r_rojo<255 THEN r_rojo <= r_rojo + 1; END IF;
                            IF SW_RGB(1)='1' AND r_verde<255 THEN r_verde <= r_verde + 1; END IF;
                            IF SW_RGB(0)='1' AND r_azul<255 THEN r_azul <= r_azul + 1; END IF;
                        end if;
                    end if;
            END CASE;

            -----------------------------------------------------------
            -- FSM Decremento (DOWN)
            -----------------------------------------------------------
            CASE s_state_down IS
                
                WHEN ST_IDLE =>
                    r_timer_down <= 0;
                    if BTN_DOWN_PULSE = '1' then
                        -- Decremento inicial
                        IF SW_RGB(2)='1' AND r_rojo>0 THEN r_rojo <= r_rojo - 1; END IF;
                        IF SW_RGB(1)='1' AND r_verde>0 THEN r_verde <= r_verde - 1; END IF;
                        IF SW_RGB(0)='1' AND r_azul>0 THEN r_azul <= r_azul - 1; END IF;
                        
                        s_state_down <= ST_WAIT;
                    end if;

                WHEN ST_WAIT =>
                    if BTN_DOWN_STATE = '0' then
                        s_state_down <= ST_IDLE;
                    else
                        if r_timer_down < C_DELAY_WAIT then
                            r_timer_down <= r_timer_down + 1;
                        else
                            r_timer_down <= 0;
                            s_state_down <= ST_TURBO;
                        end if;
                    end if;

                WHEN ST_TURBO =>
                    if BTN_DOWN_STATE = '0' then
                        s_state_down <= ST_IDLE;
                    else
                        if r_timer_down < C_DELAY_TURBO then
                            r_timer_down <= r_timer_down + 1;
                        else
                            r_timer_down <= 0;
                            -- Decremento ciclico
                            IF SW_RGB(2)='1' AND r_rojo>0 THEN r_rojo <= r_rojo - 1; END IF;
                            IF SW_RGB(1)='1' AND r_verde>0 THEN r_verde <= r_verde - 1; END IF;
                            IF SW_RGB(0)='1' AND r_azul>0 THEN r_azul <= r_azul - 1; END IF;
                        end if;
                    end if;
            END CASE;

        END IF;
    END PROCESS;

    -- Asignacion al registro de salida
    VALOR_SALIDA.ROJO  <= STD_LOGIC_VECTOR(r_rojo);
    VALOR_SALIDA.VERDE <= STD_LOGIC_VECTOR(r_verde);
    VALOR_SALIDA.AZUL  <= STD_LOGIC_VECTOR(r_azul);

END BEHAVIORAL;