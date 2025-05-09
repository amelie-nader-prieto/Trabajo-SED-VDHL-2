library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
  port (
    cuenta     : in integer;
    clk        : in std_logic;
    digsel     : out std_logic_vector(7 downto 0);
    segmentos  : out std_logic_vector(7 downto 0)
  );
end display;

architecture Behavioral of display is
  signal anodos      : integer range 0 to 2 := 0;
  signal muetra      : integer range 0 to 14 := 0;
  signal clk_counter : unsigned(19 downto 0) := (others => '0');
begin

  -- Proceso de reloj: multiplexado de dígitos
  process(clk)
  begin
    if rising_edge(clk) then
      if clk_counter = to_unsigned(200000, 20) then
        clk_counter <= (others => '0');
        if anodos = 2 then
          anodos <= 0;
        else
          anodos <= anodos + 1;
        end if;
      else
        clk_counter <= clk_counter + 1;
      end if;
    end if;
  end process;

  -- Activación de dígitos (ánodos)
  process(anodos, cuenta)
  begin
    if cuenta <= 150 then
      case anodos is
        when 0 => digsel <= "11111110"; -- unidades
        when 1 => digsel <= "11111101"; -- decenas
        when 2 => digsel <= "11111011"; -- centenas (con punto)
        when others => digsel <= "11111111";
      end case;
    else
      digsel <= "11111111"; -- display apagado si fuera de rango
    end if;
  end process;

  -- Decodificación de valor a mostrar (con punto en centena)
  process(anodos, cuenta)
    variable cen : integer;
    variable dec : integer;
    variable uni : integer;
  begin
    if cuenta <= 150 then
      cen := (cuenta / 100) mod 10;
      dec := (cuenta / 10) mod 10;
      uni := cuenta mod 10;

      case anodos is
        when 0 => muetra <= uni;               -- sin punto
        when 1 => muetra <= dec;               -- sin punto
        when 2 =>                               -- centena con punto (solo para 0 o 1)
          case cen is
            when 0 => muetra <= 10;            -- 0 con punto
            when 1 => muetra <= 11;            -- 1 con punto
            when others => muetra <= 12;       -- apagado 
          end case;
        when others => muetra <= 12;           -- apagado
      end case;
    else
      muetra <= 12; -- fuera de rango
    end if;
  end process;

  -- Tabla de segmentos 
  process(muetra)
  begin
    case muetra is
      when 0  => segmentos <= "10000001"; -- 0
      when 1  => segmentos <= "11001111"; -- 1
      when 2  => segmentos <= "10010010"; -- 2
      when 3  => segmentos <= "10000110"; -- 3
      when 4  => segmentos <= "11001100"; -- 4
      when 5  => segmentos <= "10100100"; -- 5
      when 6  => segmentos <= "10100000"; -- 6
      when 7  => segmentos <= "10001111"; -- 7
      when 8  => segmentos <= "10000000"; -- 8
      when 9  => segmentos <= "10000100"; -- 9
      when 10 => segmentos <= "00000001"; -- 0 con punto
      when 11 => segmentos <= "01001111"; -- 1 con punto
      when others => segmentos <= "11111111"; -- apagado
    end case;
  end process;

end Behavioral;