`ifndef monitor
 `define monitor

class MMonitor extends uvm_monitor;

   `uvm_component_utils(MMonitor)

   
   int trans_num = 0 ;

   virtual Interface vif;
   
   
   uvm_analysis_port#(ATransaction) trans_port;
   ATransaction trans;
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual Interface)::get(this, "", "vif", vif))
	`uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(),".vif"});
   endfunction // build_phase


   function new (string name, uvm_component parent);
      super.new(name, parent);
      trans_port = new("trans_port", this);
   endfunction // new
   
   virtual task run_phase(uvm_phase phase);
      forever
	begin
	   
	   // Address phase
	   @(posedge vif.PCLK iff vif.cb.PSEL != 0);
	   trans_num += 1;
	   trans = ATransaction::type_id::create("trans", this);
	   trans.paddr <= vif.PADDR;
	   trans.psel <= vif.PSEL;
	   // Write transaction
	   if(vif.cb.PWRITE)
	     begin
		trans.pwrite <= vif.cb.PWRITE;
		trans.pwdata <= vif.cb.PWDATA;
	     end
	   else
	     begin
		trans.pwrite <= vif.cb.PWRITE;
	     end
	   
	   @(posedge vif.PCLK);
	   assert(vif.cb.PENABLE)
	     else
	     `uvm_error("[APB]","[Master Monitor]: Protocl Violation: PEnable was not followed by setup phase")
	   wait(vif.cb.PREADY == 1);
	   if(!vif.cb.PWRITE)
	     begin
		trans.prdata <= vif.cb.PRDATA;
	     end
	   
	   trans_port.write(trans);
	   
	end
      
      

   endtask // run_phase
   
function void report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("Report: APB Master Monitor collected %0d transfers", trans_num), UVM_LOW);
endfunction : report_phase
   
endclass // MMonitor

   



`endif
