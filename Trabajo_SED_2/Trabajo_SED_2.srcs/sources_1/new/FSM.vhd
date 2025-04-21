library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is
    port(
        monedas : in std_logic_vector(3 downto 0);
        comprar_producto : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        importe_total : out integer;
        entregar_producto : out std_logic;
        led_error : out std_logic
        
    );
end entity;

architecture Behavioral of FSM is

    type states is (
        reposo,
        moneda_introducida,
        recibiendo_monedas,
        entregando_producto,
        error,
        devolver_dinero
    );
    
    signal current_state : states := reposo;
    signal next_state : states := current_state;
    
    signal i_importe : integer := 0;
    
    -- Duración del periodo del reloj (100MHz)
    constant T_clk : time := 10ns;
    -- Número de ciclos que debe durar el LED encendido
    constant duracion_led_producto : integer := 250_000_000;
    constant duracion_led_error : integer := 250_000_000;
    
    -- Señales para gestionar la temporización
    -- Se temporizan el led que indica la entrega del producto y el led que indica error
    signal contador_producto : unsigned(27 downto 0) := (others => '0');
    signal tiempo_terminado_producto : std_logic := '0';
    signal contador_error : unsigned(27 downto 0) := (others => '0');
    signal tiempo_terminado_error : std_logic := '0';

begin

    -- Gestión de los estados temporizados
    temporizacion : process(clk)
    begin
        if rising_edge(clk) then
            if current_state = entregando_producto then
                if contador_producto = duracion_led_producto - 1 then
                -- Ha finalizado la cuenta
                    tiempo_terminado_producto <= '1';
                    contador_producto <= (others => '0');
                else
                    tiempo_terminado_producto <= '0';
                    contador_producto <= contador_producto + 1;
                end if;
                
            elsif current_state = error then
                if contador_error = duracion_led_error - 1 then
                -- Ha finalizado la cuenta
                    tiempo_terminado_error <= '1';
                    contador_error <= (others => '0');
                else
                    tiempo_terminado_error <= '0';
                    contador_error <= contador_error + 1;
                end if;
            
            end if;
        
        end if;
    
    end process;
    
    -- Actualizar el estado  
    state_reg : process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Decodificar el estado siguiente
    -- (depende del estado actual y de las entradas)
    nextstate_decod : process(current_state, monedas, comprar_producto, reset)
    begin
        case current_state is
            when reposo =>
                if monedas = "1000" or monedas = "0100" or monedas = "0010" or monedas = "0001" then
                    next_state <= moneda_introducida;
                else next_state <= current_state;
                end if;
            
            when moneda_introducida =>
                next_state <= recibiendo_monedas;
            
            when recibiendo_monedas =>
                if comprar_producto = '1' then
                    if i_importe < 100 then next_state <= recibiendo_monedas;
                    elsif i_importe = 100 then next_state <= entregando_producto;
                    else next_state <= error;
                    end if;
                elsif reset = '1' then
                    next_state <= error;
                elsif monedas = "1000" or monedas = "0100" or monedas = "0010" or monedas = "0001" then
                    next_state <= moneda_introducida;
                else next_state <= current_state;
                end if;
                                
            when entregando_producto =>
            -- Estado temporizado
                if tiempo_terminado_producto = '1' then
                    next_state <= reposo;
                else
                    next_state <= current_state;
                end if;
            
            when devolver_dinero =>
                if i_importe = 0 then
                    -- se ha devuelto todo el dinero
                    next_state <= reposo;
                else
                    next_state <= current_state;
                end if;
            
            when error =>
            -- Estado temporizado
                if tiempo_terminado_error = '1' then
                    next_state <= devolver_dinero;
                else
                    next_state <= current_state;
                end if;
            
            when others =>
                next_state <= reposo;
            
        end case;
    end process;
    
    -- Decodificar las salidas
    -- (dependen sólo del estado actual)
    output_decod : process(current_state)
    begin
        case current_state is
        
            when reposo =>
                entregar_producto <= '0';
                led_error <= '0';
                i_importe <= i_importe;
            
            when moneda_introducida =>
                entregar_producto <= '0';
                led_error <= '0';
                case monedas is
                    when "1000" => i_importe <= i_importe + 100;
                    when "0100" => i_importe <= i_importe + 50;
                    when "0010" => i_importe <= i_importe + 20;
                    when "0001" => i_importe <= i_importe + 10;
                    when others => i_importe <= i_importe;
                end case;
            
            when recibiendo_monedas =>
                entregar_producto <= '0';
                led_error <= '0';
                i_importe <= i_importe;
            
            when entregando_producto =>
                entregar_producto <= '1';
                led_error <= '0';
                i_importe <= 0;
            
            when devolver_dinero =>
                entregar_producto <= '0';
                led_error <= '0';
                i_importe <= 0;
            
            when error =>
                entregar_producto <= '0';
                led_error <= '1';
                i_importe <= i_importe;
            
            when others =>
                entregar_producto <= '0';
                led_error <= '0';
                i_importe <= i_importe;
            
        end case;
    end process;
    
    importe_total <= i_importe;

end architecture;

