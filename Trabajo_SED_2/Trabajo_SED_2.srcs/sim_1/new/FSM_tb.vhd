library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity FSM_tb is
--  Port ( );
end FSM_tb;

architecture Behavioral of FSM_tb is

    component FSM is
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
    
    signal monedas : std_logic_vector := "0000";
    signal comprar_producto : std_logic := '0';
    signal reset : std_logic := '0';
    signal clk : std_logic := '0';
    signal importe_total : integer := 0;
    signal entregar_producto : std_logic := '0';
    signal led_error : std_logic := '0';

begin

    uut : FSM port map(
        monedas => monedas,
        comprar_producto => comprar_producto,
        reset => reset,
        clk => clk,
        importe_total => importe_total,
        entregar_producto => entregar_producto,
        led_error => led_error
    );

end Behavioral;
