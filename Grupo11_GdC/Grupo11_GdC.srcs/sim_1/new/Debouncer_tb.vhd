LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Debouncer_tb IS
END Debouncer_tb;
 
ARCHITECTURE behavior OF Debouncer_tb IS 
    COMPONENT Debouncer
    PORT(
         CLK : IN  std_logic;
         BTN_IN : IN  std_logic;
         PULSE_OUT : OUT  std_logic;
         BTN_STATE : OUT  std_logic
        );
    END COMPONENT;
    
    signal CLK : std_logic := '0';
    signal BTN_IN : std_logic := '0';
    signal PULSE_OUT : std_logic;
    signal BTN_STATE : std_logic;
    constant CLK_period : time := 10 ns;
 
BEGIN
    uut: Debouncer PORT MAP (
          CLK => CLK,
          BTN_IN => BTN_IN,
          PULSE_OUT => PULSE_OUT,
          BTN_STATE => BTN_STATE
        );

    CLK_process :process
    begin
        CLK <= '0'; wait for CLK_period/2;
        CLK <= '1'; wait for CLK_period/2;
    end process;
 
    stim_proc: process
    begin		
        -- Reposo
        BTN_IN <= '0'; wait for 100 ns;	

        -- Ruido al pulsar
        BTN_IN <= '1'; wait for 20 ns;
        BTN_IN <= '0'; wait for 10 ns;
        BTN_IN <= '1'; wait for 30 ns;
        BTN_IN <= '0'; wait for 5 ns;
        
        -- Pulsación firme
        BTN_IN <= '1';
        wait for 500 ns; 

        -- Soltar
        BTN_IN <= '0';
        wait;
    end process;
END;