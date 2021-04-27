class STransaction extends uvm_seq_item;

   rand logic pready;
   rand logic [`PRDATA_WIDTH-1:0] prdata;
   rand logic pslverr;



`uvm_object_utils_begin
   `uvm_field_int(pready, UVM_ALL_ON)
   `uvm_field_int(prdata, UVM_ALL_ON)
   `uvm_field_int(pslverr, UVM_ALL_ON)
`uvm_object_utils_end
   
endclass // STransaction

