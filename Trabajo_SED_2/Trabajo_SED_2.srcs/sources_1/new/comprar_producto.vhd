library IEEE;
use IEEE.std_logic_1164.ALL;


ENTITY comprar_producto IS 
    PORT ( 
        CLK: IN std_logic ;
        comp_prodasyn: in std_logic ;
        comp_prodsyn: out std_logic
); 
END comprar_producto; 

architecture Behavioral of comprar_producto is

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
        ASYNC_IN=> comp_prodasyn,
        SYNC_OUT=> sync_i
    );

    Inst_EDGEDTCTR: edgedtctr PORT MAP(
        clk =>clk,
        SYNC_IN=>sync_i,
        edge=>comp_prodsyn
    ); 

end behavioral;
