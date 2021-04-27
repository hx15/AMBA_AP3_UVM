`ifndef MSequencer
 `define MSequencer


class MSequencer extends uvm_sequencer#(ATransaction);

   `uvm_component_utils(MSequencer)
   
     function new(string name, uvm_component parent);
	super.new(name,parent);
     endfunction // new
   


endclass // MSequencer


`endif
