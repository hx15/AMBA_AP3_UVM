`ifndef monitor
 `define monitor

class MMonitor extends uvm_monitor;

   `uvm_object_utils(MMonitor)

   
   int trans_num = 0 ;

   virtual Interface vif;
   
   uvm_analysis_port#(MTransaction) trans_port;
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual Interface)::get(this, "", "vif", vif))
	`uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(),".vif"});
   endfunction // build_phase


   function new (string name, uvm_component parent);
      super.new(name, parent)
      trans_port = new("trans_port", this);
   endfunction // new
   
   virtual task run_phase();
      forever
	begin
	   $display("Hello from monitor");
	   
	   // Address phase
	   @(posedge vif.cb.PCLK iff vif.cb.PSEL != 0);
	   trans = MTransaction::type_id::create("trans", this);
	   trans.paddr <= vif.PADDER;
	   trans.psel <= vif.psel;
	   // Write transaction
	   if(vif.cb.pwrite)
	     begin
		trans.op <= 0
		trans.pwrite <= vif.cb.PWRITE;
		trans.pwdata <= vif.cb.PWDATA;
	     end
	   else
	     begin
		trans.op <= 1;
	     end
	   
	   @(posedge vif.cb.PCK);
	   assert(!vif.cb.PENABLE)
	     `uvm_error("[Master Monitor]: Protocl Violation: PEnable was not followed by setup phase")
	   wait(vif.cb.PREADY == 1);
	   
	end
      
      

   endtask // run_phase

endclass // MMonitor

   



`endif
