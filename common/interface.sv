`ifndef Interface
 `define Interface

interface Interface (input logic PCLK, input logic RESETn);

   import common_data_types::*;
   
   logic [`ADDR_WIDTH-1:0] PADDR;
   logic [`PWDATA_WIDTH-1:0] PWDATA;
   logic [`PRDATA_WIDTH-1:0] PRDATA;
   logic 		     PSEL;
   logic 		     PREADY;
   logic 		     PSLVERR;
   logic 		     PWRITE;
   logic 		     PENABLE;
   op_type op;
   


   always@(PCLK)
     if(RESETn == 0)
       reset();
   

    clocking cb @(posedge PCLK);
        default input #1ns output #1ns;  // default delay skew
        output  PSEL;
        output  PENABLE;
        output  PWRITE;
        output  PADDR;
        output  PWDATA;
        input   PREADY;
        input   PRDATA;
        input   PSLVERR;
    endclocking: cb


   task reset();
	PENABLE = 1'b0;
	PWRITE = 1'b0;
	PSEL = 1'b0;
	PADDR = 0;
	PWDATA = 0;
endtask // reset


`include "apb_if_assertions.sv"

   
endinterface 










`endif
