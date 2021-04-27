`ifndef MAgent
 `define MAgent

class MAgent extends uvm_agent;
   
  `uvm_component_utils(MAgent)
   
   MDriver apb_mdriver;
   MSequencer apb_msequencer;
   virtual Interface vif;

   
    function new(string name="MAgent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual Interface)::get(this, "", "vif", vif))
	`uvm_fatal("NO VIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
      
      apb_mdriver = MDriver::type_id::create("apb_mdriver", this);
      apb_msequencer = MSequencer::type_id::create("apb_msequencer", this);

      
   endfunction // build_phase
   
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      apb_mdriver.seq_item_port.connect(apb_msequencer.seq_item_export);
   endfunction // connect_phase
   
      
endclass // MAgent

`endif
