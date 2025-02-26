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
        error : out std_logic
        
    );
end entity;

architecture Behavioral of FSM is

    type states is (
        reposo,
        recibiendo_monedas,
        entregando_producto,
        devolver_dinero
    );
    
    signal current_state : states := reposo;
    signal next_state : states := current_state;

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
    end process;
    
    -- Decodificar las salidas
    -- (dependen sólo del estado actual)
    output_decod : process(current_state)
    begin
    end process;

end architecture;

