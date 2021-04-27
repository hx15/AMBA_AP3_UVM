`ifndef ATransaction
 `define ATransaction

class ATransaction extends uvm_sequence_item;
   
   rand logic [`ADDR_WIDTH-1:0] paddr;
   rand logic [`PWDATA_WIDTH-1:0] pwdata;
   rand logic pwrite;
   rand logic psel;
   rand logic pready;
   rand logic penable;
   rand logic pslverr;
   rand logic [`PRDATA_WIDTH-1:0] prdata;
   typedef enum {WRITE=0, READ=1, IDLE=2} op_type;
   rand op_type op;
   
     `uvm_object_utils_begin(ATransaction)
	`uvm_field_int(paddr,UVM_ALL_ON)
	`uvm_field_int(pwdata,UVM_ALL_ON)
	`uvm_field_int(penable,UVM_ALL_ON)
	`uvm_field_int(psel,UVM_ALL_ON)
	`uvm_field_int(pready,UVM_ALL_ON)
	`uvm_field_int(prdata,UVM_ALL_ON)
	`uvm_field_int(pslverr,UVM_ALL_ON)
   `uvm_object_utils_end
   
   

   constraint cons_op_type {
      op inside {[0:2]};
      if( op == 0 )
	 {
	 pwrite == 1;
	 psel == 1;
	 penable == 1;
      }
      else if ( op == 1 ) {
	 pwrite == 0;
	 psel == 1;
	 penable == 1;
      }
      else {
	 psel == 0;
	 penable == 0;
      }      
   }
   
   
   function new(string name = "ATransaction");
      super.new(name);
   endfunction // new
   

endclass // ATransaction
`endif //  `ifndef ATransaction





   
   
