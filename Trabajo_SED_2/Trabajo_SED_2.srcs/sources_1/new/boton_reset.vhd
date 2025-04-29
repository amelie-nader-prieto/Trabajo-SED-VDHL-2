library IEEE;
use IEEE.std_logic_1164.ALL;


ENTITY boton_reset IS 
    PORT ( 
        CLK: IN std_logic ;
        reset_asyn: in std_logic ;
        reset_syn: out std_logic
); 
END boton_reset; 

architecture Behavioral of boton_reset is

    signal sync_i: std_logic ;
    

    COMPONENT SYNCHRNZR
    PORT(
        CLK: in std_logic ;
        ASYNC_IN: in std_logic ;
        SYNC_OUT: out std_logic 
    );
    END COMPONENT;

    COMPONENT EDGEDTCTR
    PORT (
        CLK: IN std_logic;
        SYNC_IN : IN std_logic;
        EDGE: out std_logic  
    );
    END COMPONENT;

    begin 

    Inst_SYNCHRNZR: SYNCHRNZR PORT MAP(
        clk=>clk,
        ASYNC_IN=> reset_asyn,
        SYNC_OUT=> sync_i
    );

    Inst_EDGEDTCTR: edgedtctr PORT MAP(
        clk =>clk,
        SYNC_IN=>sync_i,
        edge=>reset_syn
    ); 

end behavioral;
