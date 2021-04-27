   
`define ADDR_WIDTH 16
`define PWDATA_WIDTH 16
`define PSEL_WIDTH 1
`define PRDATA_WIDTH 16
`define NUM_SLAVES 2

`ifndef types
`define types
typedef enum {WRTITE=0, READ=1, IDLE=2} op_type;
`endif
