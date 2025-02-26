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

begin
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
            
            when moneda_introducida =>
            
            when recibiendo_monedas =>
            
            when entregando_producto =>
            
            when devolver_dinero =>
            
            when error =>
            
            when others =>
            
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

