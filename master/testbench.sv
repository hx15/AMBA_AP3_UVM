module apb_top_testbench;

   reg clk;
   reg RESETn;
Interface vif(clk, RESETn);
   
  
   initial
     begin
	$dumpfile("dump.vcd");
	$dumpvars();
     end

   initial 
     begin
	uvm_config_db#(virtual Interface)::set(null,"*","vif",vif);
	run_test("Test");
     end
   
endmodule // apb_top_testbench

