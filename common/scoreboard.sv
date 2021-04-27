`ifndef scoreboard
 `define scoreboard

class scoreboard extends uvm_scoreboard;

   uvm_analysis_imp#(ATransaction, scoreboard) aimp;
   
   protected int write_count = 0;
   protected int read_count = 0;
   protected int slave_err_count = 0;
   protected int mismatches_count = 0;
   protected int signed mem [int unsigned];
   
   
   `uvm_component_utils_begin(scoreboard)
      `uvm_field_int(write_count, UVM_ALL_ON)
      `uvm_field_int(read_count, UVM_ALL_ON|UVM_DEC)
      `uvm_field_int(slave_err_count, UVM_ALL_ON|UVM_DEC)
      `uvm_field_int(mismatches_count, UVM_ALL_ON|UVM_DEC)
   `uvm_component_utils_end



   function new (string name, uvm_component parent = null);
      super.new(name, null);
      aimp = new("aimp", this);
   endfunction // new


   function void write(input ATransaction trans);
      if(trans.pwrite == 0)
	begin
	   compare_mem(trans);
	   read_count++;
	   
	end
      
      else
	begin
	   write_to_mem(trans);
	   write_count++;
	   
	end
      
   endfunction // write



   function void compare_mem(ATransaction trans);
      int unsigned 	 expected, data;
      data = trans.prdata;
      expected = entry_exits(trans) ? mem[trans.paddr] : data;
      if(expected != data) begin
        $display("Read data mismatch.  Expected : %0h.  Actual : %0h", expected, data);
	 mismatches_count++;
	 end
      
   endfunction // compare_mem

   function int entry_exits(ATransaction trans);
      if(mem[trans.paddr] != 0)
	begin
	   $display("Reading an existing location...");
	   return 1;
	end
      else
	return 0;
   endfunction // entry_exits
   

   
   function void write_to_mem(ATransaction trans);
      if(mem[trans.paddr] != 0)
	begin
	   $display("Writing to an existing location.. addr=%0h, write data=%0h", trans.paddr, trans.pwdata);
	   mem[trans.paddr] = trans.pwdata;
	end
      
      else begin
	 mem[trans.paddr] = trans.pwdata;
	end
	   
   endfunction // write_to_mem
   

   function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: APB scoreboard > Mismatches:  %0d, Write Transfers: %0d , Read Transfers: %0d", mismatches_count, write_count, read_count), UVM_LOW);
   endfunction // report_phase
   
endclass // scoreboard


`endif
