
class Test extends uvm_test;
`uvm_component_utils(Test)


   //------------------------
   // env components
   //------------------------

   APBEnv env;
   MSequence base_sequence;
   MSeq_write_read_idle_seq  wr_rd_idle_seq;
   
   function new(string name, uvm_component parent);
      super.new("APBEnv", parent);
   endfunction // new


   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = APBEnv::type_id::create("env", this);
      wr_rd_idle_seq =  MSeq_write_read_idle_seq::type_id::create("wr_rd_idle_seq");
      
   endfunction:build_phase



   virtual function void end_of_elaboration();

      print();
      

   endfunction // end_of_elaboration
   
   

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      fork
	 wr_rd_idle_seq.start(env.apb_magent.apb_msequencer);
      join_any

      phase.drop_objection(this);


   endtask // run_phase



   function void report_phase(uvm_phase phase);
      uvm_report_server svr;
      super.report_phase(phase);

      svr = uvm_report_server::get_server();
      `uvm_info(get_type_name(), $sformatf( "%d read transactions sent\n %d write transactions sent\n %d idle transactions sent",wr_rd_idle_seq.wr_count,wr_rd_idle_seq.rd_count, wr_rd_idle_seq.idle_count), UVM_NONE)
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 
      

endclass // Test
