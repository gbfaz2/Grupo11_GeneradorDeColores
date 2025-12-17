LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PWM_SSDM_LFSR IS
    GENERIC (
        G_WIDTH : INTEGER := 8 -- (8 BITS => 2^8 = 256 COLORES)
    );
    PORT ( 
        CLK_PWM       : IN  STD_LOGIC;
        RST           : IN  STD_LOGIC;
        DUTY_CYCLE_IN : IN  STD_LOGIC_VECTOR (G_WIDTH-1 DOWNTO 0);
        PWM_OUT       : OUT STD_LOGIC
    );
END PWM_SSDM_LFSR;

ARCHITECTURE BEHAVIORAL OF PWM_SSDM_LFSR IS

    -- REGISTRO DE 16 BITS
    -- INICIALIZAMOS EN DISTINTO DE 0 ( 0 XOR 0 = 0 )
    SIGNAL R_LFSR : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"ACE1";   
    SIGNAL FEEDBACK : STD_LOGIC;
    SIGNAL RANDOM_VAL : UNSIGNED(G_WIDTH-1 DOWNTO 0);

BEGIN

    -- GENERADOR DE ALEATORIEDAD
    LFSR : PROCESS (CLK_PWM, RST)
    BEGIN
        IF RST = '1' THEN
            R_LFSR <= x"ACE1"; -- RESETEO DISTINTO DE 0
        ELSIF RISING_EDGE(CLK_PWM) THEN
        
            -- MEZCLADORA DE NUMEROS
            
            -- PASO 1: COGER LOS BITs
            -- Bit:   15  14  13  12  11  10   9   8   7   6   5   4   3   2   1   0
            -- Valor: (1)  0  (1) (0) 1   (1)  0   0   1   1   1   0   0   0   0   1
            
            -- PASO 2: XOR           
            -- FEEDBACK = 1 XOR 1 XOR 0 XOR 1
            
            -- PASO 3: NUMERO NUEVO
            -- ORIGINAL: 1 010 1100 1110 0001
            -- QUITAMOS EL PRIMER BIT: 010 1100 1110 0001
            -- AÑADIMOS FEEDBACK: 0101 1001 1100 0011           
            
            FEEDBACK <= R_LFSR(15) XOR R_LFSR(13) XOR R_LFSR(12) XOR R_LFSR(10);
            R_LFSR <= R_LFSR(14 DOWNTO 0) & FEEDBACK;
        END IF;
    END PROCESS;

    RANDOM_VAL <= unsigned(R_LFSR(G_WIDTH-1 DOWNTO 0));

    -- COMPARADOR
    PWM_OUT <= '1' WHEN (RANDOM_VAL < unsigned(DUTY_CYCLE_IN)) ELSE '0';

END BEHAVIORAL;