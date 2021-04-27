`ifndef APBEnv
`define APBEnv
class APBEnv extends uvm_env;
   `uvm_component_utils(APBEnv)
   virtual Interface vif;
   MAgent apb_magent;
   scoreboard scoreboard_h;
   MMonitor apb_monitor;


   function new(string name = "apb_environment", uvm_component parent);
     super.new(name, parent);
   endfunction // new


   virtual function void build_phase(uvm_phase phase);
      
     super.build_phase(phase);
      apb_monitor = MMonitor::type_id::create("apb_monitor", this);
      // create the aggent
      apb_magent = MAgent::type_id::create("apb_magent",this);
      scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);
      
   endfunction // build_phase



   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(!uvm_config_db#(virtual Interface)::get(this, "", "vif", vif))
	`uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

      apb_monitor.trans_port.connect(scoreboard_h.aimp);
      
   endfunction // connect_phase


   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);

   endtask: run_phase

      
     



endclass // APBEnv
`endif
