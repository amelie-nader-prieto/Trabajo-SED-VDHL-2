library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity top is
--generic(N:positive:=3);
--??generic(M:positive:=7);
 PORT (
        CLK       : IN std_logic;                             
        RST       : IN std_logic;  
        COMP_PRODUCTO:in std_logic ;                         
        MON: in std_logic_vector (3 downto 0);
        ENTREGAR_PRODUCTO: out std_logic;
        LED_ERROR: out std_logic;
        SEGMENTOS : OUT std_logic_vector(7 DOWNTO 0);
        DIGSEL:out std_logic_vector (7 downto 0)
        
    );
end top;

architecture Behavioral of top is
    SIGNAL mon_int : std_logic_vector(3 DOWNTO 0);   
    SIGNAL reset : std_logic; 
    --SIGNAL puls : std_logic_vector(1DOWNTO 0);         
    SIGNAL comp_prod : std_logic;         
    SIGNAL importe:integer;         
    --signal reset_contador : std_logic;
    --signal int_sync_contador : std_logic_vector(3 downto 0);


COMPONENT MONEDAS is
    generic(N:positive:=3);
    port(
        clk : IN std_logic;
        bot_asyn:IN std_logic_vector (N downto 0);
        bot_syn:OUT std_logic_vector (N downto 0)
    );
end component;

COMPONENT boton_reset is
    
    port(
        clk : IN std_logic;
        reset_asyn:IN std_logic;
        reset_syn:OUT std_logic
    );
end component;

COMPONENT comprar_producto is
    
    port(
        clk : IN std_logic;
        comp_prodasyn:IN std_logic;
        comp_prodsyn:OUT std_logic
    );
end component;
 
COMPONENT display IS
    PORT (
         clk       : IN std_logic;                             
         cuenta   : IN integer;             
         digsel : OUT std_logic_vector(7 DOWNTO 0);
        segmentos : OUT std_logic_vector(7 DOWNTO 0)       
          
             
    );
END COMPONENT; 

component FSM is
  generic(N:positive:=3);
    Port (
        monedas : in std_logic_vector(N downto 0);
        comprar_producto : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        importe_total : out integer;
        entregar_producto : out std_logic;
        led_error : out std_logic
        );
end component;



begin


    Inst_MONEDAS:MONEDAS
        PORT MAP (
          CLK=>clk,
          bot_asyn=>mon,
          bot_syn=>mon_int
        );
    Inst_boton_reset:boton_reset
        PORT MAP (
                clk=>clk,  
                reset_asyn=>rst,
                reset_syn=>reset
        );
    Inst_comprar_producto:comprar_producto
        PORT MAP (
                clk=>clk,  
                comp_prodasyn=>comp_producto,
                comp_prodsyn=>comp_prod
        );
        
    Inst_display:display
        PORT MAP (
                clk=>clk,  
                cuenta=>importe,
                digsel=>digsel,
                segmentos=>segmentos
        );
    Inst_FSM: FSM
        PORT MAP (
           monedas=>mon_int,
           comprar_producto=>comp_prod,
           reset=>reset,
           clk=>clk,
           importe_total=>importe,
           entregar_producto=>entregar_producto,
           led_error=>led_error
           );
    
end Behavioral;
