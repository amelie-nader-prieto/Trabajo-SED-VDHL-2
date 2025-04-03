library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity display_tb is
end;

architecture bench of display_tb is

  component display
    PORT(
      cuenta :IN integer;
      clk: IN std_logic;
      digsel : OUT std_logic_vector(7 DOWNTO 0);
      segmentos : OUT std_logic_vector(7 DOWNTO 0)
    );
  end component;

  signal cuenta: integer;
  signal clk: std_logic;
  signal digsel: std_logic_vector(7 DOWNTO 0);
  signal segmentos: std_logic_vector(7 DOWNTO 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: display port map ( cuenta    => cuenta,
                          clk       => clk,
                          digsel    => digsel,
                          segmentos => segmentos );

  stimulus: process
  begin

    -- Put initialisation code here
	cuenta<= 0;
    wait for 100 ns;

    -- Put test bench stimulus code here
    cuenta<=10;
    wait for 100 ns;
    
    cuenta<=20;
    wait for 100 ns;
    
    cuenta<=30;
    wait for 100 ns;

    cuenta<=40;
    wait for 100 ns;
    
    cuenta<=50;
    wait for 100 ns;
    
    cuenta<=60;
    wait for 100 ns;
    
    cuenta<=70;
    wait for 100 ns;
    
    cuenta<=80;
    wait for 100 ns;
    
    cuenta<=90;
    wait for 100 ns;
    
    cuenta<=100;
    wait for 100 ns;
    
    cuenta<=110;
    wait for 100 ns;
    
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