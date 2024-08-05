package utilities is
--Declaration of FSM type. In VHDL you can define your own type and the values they may take
--For information about this please see: https://fpgatutorial.com/vhdl-records-arrays-and-custom-types/
TYPE FSM_STATES IS (IDLE_STATE, WAIT_STATE, READ_STATE, WRITE_STATE);
--TYPE FSM_STATES IS (IDLE_STATE, READ_STATE, WRITE_STATE);
end package;
