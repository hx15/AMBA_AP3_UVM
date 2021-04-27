`ifndef MDriver
 `define MDriver

class MDriver extends uvm_driver#(ATransaction);

   `uvm_component_utils(MDriver)
   virtual Interface vif;

   int 	   num_trans = 0;
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual Interface)::get(this, "", "vif", vif))
	`uvm_fatal("NO_VIF", {"Virtual interface must be set for: ", get_full_name(),".vif"});
      
   endfunction // build_phase


   task run_phase(uvm_phase phase);
      vif.reset();
      forever
	begin
	   ATransaction trans;
	   get_sequence_from_sequencer(trans);
	   drive_transaction(trans);
	   seq_item_port.item_done();
	end
      
   endtask // run_phase




   task get_sequence_from_sequencer(ref ATransaction trans);
      seq_item_port.get_next_item(trans);
   endtask // get_sequence_from_sequencer
   
   
   task drive_transaction(input ATransaction trans);
      case(trans.op)
	0: drive_write_seq(trans);
	1: drive_read_seq(trans);
	2: drive_idle_seq(trans);
	
      endcase // case (trans.op)
      
	
      
   endtask // drive_transaction
   
  
   function new(string name = "MDriver" , uvm_component parent);
      super.new(name, parent);
   endfunction // new

   
   task drive_write_seq(input ATransaction trans);
      this.num_trans ++;
      
      @(vif.cb);
      vif.op = trans.op;
      vif.cb.PADDR <= trans.paddr;
      vif.cb.PWRITE <= trans.pwrite;
      vif.cb.PWDATA <= trans.pwdata;
      vif.cb.PSEL <= trans.psel;
      @(vif.cb);
      vif.cb.PENABLE <= trans.penable;
      wait(vif.cb.PREADY == 1);
      vif.cb.PENABLE <= 1'b0;
      
   endtask // drive_write_seq
   
   task drive_read_seq(input ATransaction trans);
      this.num_trans ++;
      @(vif.cb);
      vif.op <= trans.op;
      vif.cb.PADDR <= trans.paddr;
      $display("psel_value:%d", trans.psel);
      vif.cb.PSEL <= trans.psel;
      vif.cb.PWRITE <= trans.pwrite;
      @(vif.cb);
      vif.cb.PENABLE <= trans.penable;
      wait(vif.cb.PREADY == 1);
      
   endtask // drive_write_seq

   task drive_idle_seq(input ATransaction trans);
      @(vif.cb);
      vif.cb.PENABLE <= trans.penable;
      vif.cb.PSEL <= trans.psel;
      
   endtask // drive_write_seq


   function void report_phase(uvm_phase phase);
      `uvm_info (get_full_name(), $sformatf("Report: APB Master Driver has driven %0d transfers", num_trans), UVM_LOW)
   endfunction // report_phase
   
endclass // MDriver

     

`endif
