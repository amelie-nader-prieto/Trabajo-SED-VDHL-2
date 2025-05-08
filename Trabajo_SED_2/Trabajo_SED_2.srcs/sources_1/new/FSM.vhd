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

    -- Instanciamos este bloque para debugging
    component ila_1 is
        port(
            clk : in std_logic;
            probe0 : in std_logic_vector(3 downto 0);
            probe1 : in std_logic_vector(3 downto 0)
        );
    end component;
    component ila_0 is
        port(
            clk : in std_logic;
            probe0 : in std_logic_vector(32 downto 0)
        );
    end component;

    type states is (
        reposo,
        introducido_100,
        introducido_50,
        introducido_20,
        introducido_10,
        recibiendo_monedas,
        entregando_producto,
        error,
        devolver_dinero,
        moneda_introducida
    );
    
    signal current_state : states := reposo;
    signal next_state : states := current_state;
    
    signal i_importe : integer := 0;
    signal importe_siguiente : integer := 0;
    
    -- Duración del periodo del reloj (100MHz)
    constant T_clk : time := 10ns;
    -- Número de ciclos que debe durar el LED encendido
    
    -- Valores reales
    constant duracion_led_producto : integer := 250_000_000;
    constant duracion_led_error : integer := 250_000_000;
    
    -- Valores para simular
    --constant duracion_led_producto : integer := 25;
    --constant duracion_led_error : integer := 25;
    
    -- Señales para gestionar la temporización
    -- Se temporizan el led que indica la entrega del producto y el led que indica error
    signal contador_producto : unsigned(27 downto 0) := (others => '0');
    signal tiempo_terminado_producto : std_logic := '0';
    signal contador_error : unsigned(27 downto 0) := (others => '0');
    signal tiempo_terminado_error : std_logic := '0';
    
    
    -- SEÑALES PARA DEBUGGING
    signal current_state_debug : std_logic_vector(3 downto 0);
    signal next_state_debug : std_logic_vector(3 downto 0);
    signal importe_debug : std_logic_vector(32 downto 0);

begin

    -- Debugging
    states_ila : ila_1 port map(
        clk => clk,
        probe0 => current_state_debug,
        probe1 => next_state_debug
    );
    current_state_debug <= std_logic_vector(to_unsigned(states'pos(current_state),current_state_debug'length));
    next_state_debug <= std_logic_vector(to_unsigned(states'pos(next_state),next_state_debug'length));
    
    importe_ila : ila_0 port map(
        clk => clk,
        probe0 => importe_debug
    );
    importe_debug <= std_logic_vector(to_unsigned(i_importe, importe_debug'length));


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
            i_importe <= importe_siguiente;
        end if;
    end process;
    
    -- Decodificar el estado siguiente
    -- (depende del estado actual y de las entradas)
    nextstate_decod : process(current_state, monedas, comprar_producto, reset, tiempo_terminado_producto, tiempo_terminado_error)--, i_importe)
    begin
        case current_state is
            when reposo =>
                if monedas = "1000" then next_state <= introducido_100;
                elsif monedas = "0100" then next_state <= introducido_50;
                elsif monedas = "0010" then next_state <= introducido_20;
                elsif monedas = "0001" then next_state <= introducido_10;
                else next_state <= current_state;
                end if;
--                if monedas = "1000" or monedas = "0100" or monedas = "0010" or monedas = "0001" then
--                    next_state <= moneda_introducida;
--                else next_state <= current_state;
--                end if;
            
--            when moneda_introducida =>
--                next_state <= recibiendo_monedas;
            
            when introducido_100 => next_state <= recibiendo_monedas;
            when introducido_50 => next_state <= recibiendo_monedas;
            when introducido_20 => next_state <= recibiendo_monedas;
            when introducido_10 => next_state <= recibiendo_monedas;
            
            when recibiendo_monedas =>
                -- priorizamos el reset
                if reset = '1' then
                    next_state <= error;
                elsif comprar_producto = '1' then
                    if i_importe < 100 then next_state <= recibiendo_monedas;
                    elsif i_importe = 100 then next_state <= entregando_producto;
                    else next_state <= error;
                    end if;
                elsif monedas = "1000" then next_state <= introducido_100;
                elsif monedas = "0100" then next_state <= introducido_50;
                elsif monedas = "0010" then next_state <= introducido_20;
                elsif monedas = "0001" then next_state <= introducido_10;
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
                importe_siguiente <= i_importe;
            
            --when moneda_introducida =>
--                entregar_producto <= '0';
--                led_error <= '0';
----                case monedas is
----                    when "1000" => i_importe <= i_importe + 100;
----                    when "0100" => i_importe <= i_importe + 50;
----                    when "0010" => i_importe <= i_importe + 20;
----                    when "0001" => i_importe <= i_importe + 10;
----                    when others => i_importe <= i_importe;
--                --end case;
            
            when introducido_100 =>
                entregar_producto <= '0';
                led_error <= '0';
                importe_siguiente <= i_importe + 100;
            
            when introducido_50 =>
                entregar_producto <= '0';
                led_error <= '0';
                importe_siguiente <= i_importe + 50;
            
            when introducido_20 =>
                entregar_producto <= '0';
                led_error <= '0';
                importe_siguiente <= i_importe + 20;
            
            when introducido_10 =>
                entregar_producto <= '0';
                led_error <= '0';
                importe_siguiente <= i_importe + 10;
            
            
--            when recibiendo_monedas =>
--                entregar_producto <= '0';
--                led_error <= '0';
--                i_importe <= i_importe;
            
            when entregando_producto =>
                entregar_producto <= '1';
                led_error <= '0';
                importe_siguiente <= 0;
            
            when devolver_dinero =>
                entregar_producto <= '0';
                led_error <= '0';
                importe_siguiente <= 0;
            
            when error =>
                entregar_producto <= '0';
                led_error <= '1';
                importe_siguiente <= i_importe;
            
            when others =>
                entregar_producto <= '0';
                led_error <= '0';
                importe_siguiente <= i_importe;
            
        end case;
    end process;
        
    importe_total <= i_importe;

end architecture;
