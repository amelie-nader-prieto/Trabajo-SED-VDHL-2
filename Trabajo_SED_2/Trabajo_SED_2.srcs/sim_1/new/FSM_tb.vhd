library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity FSM_tb is
end;

architecture bench of FSM_tb is

  component FSM
      port(
          monedas : in std_logic_vector(3 downto 0);
          comprar_producto : in std_logic;
          reset : in std_logic;
          clk : in std_logic;
          importe_total : out integer;
          entregar_producto : out std_logic;
          led_error : out std_logic
      );
  end component;

  signal monedas: std_logic_vector(3 downto 0);
  signal comprar_producto: std_logic;
  signal reset: std_logic;
  signal clk: std_logic;
  signal importe_total: integer;
  signal entregar_producto: std_logic;
  signal led_error: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: FSM port map ( monedas           => monedas,
                      comprar_producto  => comprar_producto,
                      reset             => reset,
                      clk               => clk,
                      importe_total     => importe_total,
                      entregar_producto => entregar_producto,
                      led_error         => led_error );

  stimulus: process
  begin

    -- Put initialisation code here
    reset <= '0';
    comprar_producto <='0';
    monedas<="0000";
    wait for 20 ns;

    -- Put test bench stimulus code here

    --reposo => moneda_introducida => recibiendo_moneda
    -- => comprar_producto =1 importe<100 =>recibiendo monedas => importe=100
    -- =>entregando producto => reposo
    monedas<="0001"; --10 cents
    wait for 20 ns;
    monedas<="0010"; --20 cents + 10 cents = 30 cents
    wait for 20 ns;
    monedas<="0010"; --20 cents + 30 cents = 50 cents
    wait for 20 ns;
    monedas<="0000";
    wait for 20 ns;
    
    comprar_producto<='1'; --importe <100
    wait for 20 ns;
    comprar_producto<='0';
    wait for 20 ns;
    
    monedas<="0100"; --50 cents + 50 cents = 100 cents
    wait for 20 ns;
    monedas<="0000";
    wait for 20 ns;
    
    comprar_producto<='1'; --importe =100 entregando producto
    wait for 20 ns;
    comprar_producto<='0';
    wait for 20 ns;
    
    wait for 1000ns; -- debería volver al reposo
    
    --wait for 2.5*100_000_000 ns; --debería volver al reposo
    
    -- importe = 0, reposo
    -- probamos el estado de error
    monedas <= "1000"; -- 100 cents
    wait for 20ns;
    monedas <= "1000"; -- 100 + 100 = 200 cents
    wait for 20ns;
    
    comprar_producto <= '1'; -- importe > 100 -> error
    wait for 20ns;
    comprar_producto <= '0';
    wait for 20ns;
    
    wait for 1000ns; -- debería volver al reposo
    
    -- importe = 0, reposo
    -- probamos el reset
    
    -- reposo -> moneda introducida -> recibiendo monedas
    monedas <= "0010"; 
    wait for 20ns;
    monedas <= "0000";
    wait for 20ns;
    
    -- recibiendo monedas => error
    reset <= '1';
    wait for 20ns;
    reset <= '0';
    wait for 20ns;
    
    wait for 1000ns; -- debería volver al reposo
    
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
