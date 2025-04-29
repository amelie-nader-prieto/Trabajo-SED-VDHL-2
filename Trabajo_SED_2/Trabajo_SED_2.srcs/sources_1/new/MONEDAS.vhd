library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MONEDAS is
  Port (
        clk:in std_logic;
        bot_asyn: in std_logic_vector (3 downto 0);
        bot_syn: out std_logic_vector (3 downto 0)
);
end MONEDAS;

architecture Behavioral of MONEDAS is
signal syncout_edgein: std_logic_vector (3 downto 0);


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
    Inst_SYNCHRNZR_3: SYNCHRNZR PORT MAP(
        clk=>clk,
        ASYNC_IN => bot_asyn(3),
        SYNC_OUT => syncout_edgein(3)
    );
    Inst_SYNCHRNZR_2: SYNCHRNZR PORT MAP(
        clk=>clk,
        ASYNC_IN => bot_asyn(2),
        SYNC_OUT => syncout_edgein(2)
    );
    Inst_SYNCHRNZR_1: SYNCHRNZR PORT MAP(
        clk=>clk,
        ASYNC_IN=> bot_asyn (1),
        SYNC_OUT=> syncout_edgein (1)
    );
    Inst_SYNCHRNZR_0: SYNCHRNZR PORT MAP(
        clk=>clk,
        ASYNC_IN=> bot_asyn (0),
        SYNC_OUT=> syncout_edgein (0)
    );
    
    Inst_EDGEDTCTR_3: edgedtctr PORT MAP(
        clk =>clk,
        SYNC_IN=>syncout_edgein (3),
        edge=> bot_syn (3)
    );
    Inst_EDGEDTCTR_2: edgedtctr PORT MAP(
        clk =>clk,
        SYNC_IN=>syncout_edgein (2),
        edge=> bot_syn (2)
    ); 
    Inst_EDGEDTCTR_1: edgedtctr PORT MAP(
        clk =>clk,
        SYNC_IN=>syncout_edgein (1),
        edge=> bot_syn (1)
    ); 
    Inst_EDGEDTCTR_0: edgedtctr PORT MAP(
        clk =>clk,
        SYNC_IN=>syncout_edgein (0),
        edge=> bot_syn (0)
    );  

end Behavioral;