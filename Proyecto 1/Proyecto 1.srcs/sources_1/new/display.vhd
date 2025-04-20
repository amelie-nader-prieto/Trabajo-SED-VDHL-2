library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity display is
  PORT(
    cuenta :  in integer;
    clk: IN std_logic;
    digsel : OUT std_logic_vector(7 DOWNTO 0);
    segmentos : OUT std_logic_vector(7 DOWNTO 0) --se tiene en cuenta el punto -> 1 bits mas
  );
end display;

architecture Behavioral of display is
    signal anodos: natural range 0 to 7 := 0;
    signal muetra: natural range 0 to 18 := 0;
    signal clk_counter: natural range 0 to 30000 := 0;
begin
  process(clk)
    begin
       if rising_edge(clk) then
         clk_counter <= clk_counter + 1;
         if clk_counter >= 300 then
            clk_counter <= 0;
            if anodos = 7 then
               anodos <= 0;
            else
               anodos <= anodos + 1;
            end if;
         end if;
       end if;
    end process;
   process(anodos, cuenta)
     begin
      if cuenta <= 100 then --entre 0 a 1.0
         case anodos is
           when 0 => digsel <= "11111110";
           when 1 => digsel <= "11111101";
           when 2 => digsel <= "11111011";
           when others => digsel <= "11111111";
         end case;
      else
         digsel <= "11111111";
      end if;
   end process;

   process(anodos, cuenta)
     begin
       case cuenta is
         when 0 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 0;
             when 2 => muetra <= 16;
             when others => muetra <= 12;
           end case;
         when 10 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 1;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 20 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 2;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 30 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 3;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 40 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 4;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 50 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 5;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 60 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 6;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 70 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 7;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 80 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 8;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 90 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 9;
             when 2 => muetra <= 10;
             when others => muetra <= 12;
           end case;
         when 100 => 
           case anodos is
             when 0 => muetra <= 0;
             when 1 => muetra <= 0;
             when 2 => muetra <= 11;
             when others => muetra <= 12;
           end case;
         when others => 
           muetra <= 12;
       end case;
   end process;

   process(muetra)
     begin
      case muetra is
       when 0 => segmentos <= "10000001"; --0
       when 1 => segmentos <= "11001111"; --1
       when 2 => segmentos <= "10010010"; --2
       when 3 => segmentos <= "10000110"; --3
       when 4 => segmentos <= "11001100"; --4
       when 5 => segmentos <= "10100100"; --5
       when 6 => segmentos <= "10100000"; --6
       when 7 => segmentos <= "10001111"; --7
       when 8 => segmentos <= "10000000"; --8
       when 9 => segmentos <= "10000100"; --9
       when 10 => segmentos <= "00000001"; --0 con punto
       when 11 => segmentos <= "01001111"; --1 con punto
       when 12 => segmentos <= "11111111"; --No se muestra nada
       when others => segmentos <= "11111111"; 
     end case;
   end process;

end Behavioral;