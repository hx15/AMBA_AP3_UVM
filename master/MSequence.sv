`ifndef MSequence
`define MSequence

class MSequence extends uvm_sequence#(ATransaction);

   // This class just randomizes stuff, its our base line.

   `uvm_object_utils(MSequence)
   
   function new (string name = "MSequence");
      super.new(name);
   endfunction // new


   virtual task body();
   endtask // body
   

endclass // MSequence

     



class MSeq_write extends uvm_sequence#(ATransaction);

   `uvm_object_utils(MSeq_write)
   ATransaction req;
   
   
   function new (string name = "MSeq_write" );
      super.new(name);
   endfunction // new


   virtual task body();
      begin
	 
	 `uvm_info(get_type_name(), $sformatf("%s starting...", get_sequence_path()), UVM_MEDIUM)
	 req = ATransaction::type_id::create("req");
	 assert(req.randomize() with {req.op == 0; req.paddr >= 200 ; req.paddr <= 220;})
	 wait_for_grant();
	 send_request(req);
	 wait_for_item_done();
      end
      
   endtask // body
   


endclass // MSeq_write


class MSeq_write_narrow_addr extends MSeq_write;

   `uvm_object_utils(MSeq_write_narrow_addr)
   rand ATransaction req;
   
   function new (string name = "MSeq_write_narrow_addr" );
      super.new(name);
   endfunction // new

   
   virtual task body();
      begin
	 `uvm_info(get_type_name(), $sformatf("%s starting...", get_sequence_path()), UVM_MEDIUM)
	 req = ATransaction::type_id::create("req");
	 assert(req.randomize() with {req.op == 0; req.paddr == 200;})
	   wait_for_grant();
	 send_request(req);
	 wait_for_item_done();
      end
      
   endtask // body
   


endclass // MSeq_write

class MSeq_read extends uvm_sequence#(ATransaction);
   
   `uvm_object_utils(MSeq_read)
   ATransaction req;
   
   function new (string name = "MSeq_read" );
      super.new(name);
   endfunction // new


   virtual task body();
      begin
	 `uvm_info(get_type_name(), $sformatf("%s starting...", get_sequence_path()), UVM_MEDIUM)
	 req = ATransaction::type_id::create("req");
	 assert(req.randomize() with {req.op == 1; req.psel == 1;})
	 wait_for_grant();
	 send_request(req);
	 wait_for_item_done();
	 `uvm_info("", req.sprint(), UVM_HIGH)
	end
      
   endtask // body

endclass // MSeq_read


class MSeq_read_narrow_addr extends uvm_sequence#(ATransaction);
   
   `uvm_object_utils(MSeq_read_narrow_addr)
   ATransaction req;
   
   function new (string name = "MSeq_read" );
      super.new(name);
   endfunction // new


   virtual task body();
      begin
	 `uvm_info(get_type_name(), $sformatf("%s starting...", get_sequence_path()), UVM_MEDIUM)
	 req = ATransaction::type_id::create("req");
	 assert(req.randomize() with {req.op == 1; req.psel == 1; req.paddr >= 200 ; req.paddr <= 220;})
	 wait_for_grant();
	 send_request(req);
	 wait_for_item_done();
	 `uvm_info("", req.sprint(), UVM_HIGH)
	end
      
   endtask // body

endclass // MSeq_read


class MSeq_idle extends uvm_sequence#(ATransaction);
   
   `uvm_object_utils(MSeq_idle)
   ATransaction req;
   
   
   function new (string name = "MSeq_read" );
      super.new(name);
   endfunction // new


   virtual task body();
      begin
	 `uvm_info(get_type_name(), $sformatf("%s starting...", get_sequence_path()), UVM_MEDIUM)
	 req = ATransaction::type_id::create("req");
	 assert(req.randomize() with {req.op == 2;});
	 wait_for_grant();
	 send_request(req);
	 wait_for_item_done();
	 `uvm_info("", req.sprint(), UVM_HIGH)
      end
      
      
   endtask // body


endclass // MSeq_write


class MSeq_write_read_idle_seq extends MSequence;

   `uvm_object_utils(MSeq_write_read_idle_seq)

   MSeq_idle i_seq;
   MSeq_read_narrow_addr r_seq;
   MSeq_write_narrow_addr  w_seq;
   rand int unsigned num_trans;
   
   int idle_count = 0;
   int wr_count = 0;
   int rd_count = 0;
   
   function new(string name = "MSeq_write_read_idle_seq");
      super.new(name);
   endfunction // new

   constraint num_trans_ct { num_trans == 20; }
   
   virtual task body();
      begin
	 this.randomize();
	 for (int i = 0; i < num_trans ; i++)
	   begin
	      `uvm_info(get_type_name(), $sformatf("%s starting...", get_sequence_path()), UVM_MEDIUM)   
	     //  `uvm_do(i_seq)
	      `uvm_create(r_seq)
	      
	      r_seq.randomize();
	      r_seq.body();
	      rd_count++;
	      
	      `uvm_do(w_seq)
	      wr_count++;
	      
	      `uvm_do(i_seq)
	      idle_count++;
	      
	   end
	 
      end
   endtask // body


	
endclass // MSeq_write_read_idle_seq

`endif
   
