`ifdef ABV

      `define IDLE   (!PSEL && !PENABLE)
      `define ADDR_PHASE  (PSEL && !PENABLE)
      `define ACCESS_PHASE (PSEL && PENABLE)

initial
  $display("[ABV] Monitoring Protocol Violations....");



   // Rule #1: state machine can not go from IDLE to ACCESS directly...

   property prop_idle_to_access_phase_directly;
      @(posedge PCLK) disable iff (!RESETn)
	(`IDLE)  |=> (`ADDR_PHASE);
   endproperty // prop_idle_to_access_phase_directly

   assert property(prop_idle_to_access_phase_directly);
   


   // rule2: after psel is asserted high penable should follow suite in the next cycle:
   // a gap in this rule is that it is initiaied from idle state however, if we where in access state and wanted to go back into SETUP phase for another transfer (rd/wr) it wont be detected. a different assertion must be written for that case...
   
   property prop_penable_asserted_after_psel;
      @(posedge PCLK) disable iff (!RESETn)
	($rose(PSEL) |=> (PENABLE));   
   endproperty // prop_penable_asserted_after_psel
   
   assert property(prop_penable_asserted_after_psel);

   // rule 3 : after reset, PSEL and PENABLE must be low go low..

   property prop_penable_psel_low_after_reset;
      @(negedge RESETn)
	(!PSEL && !PENABLE);
   endproperty // prop_penable_psel_low_after_reset

   assert property(prop_penable_psel_low_after_reset);

   // rule 4: PWDATA and PADDR must remain stable throughout the transistion from address phase and access phase (write cycle)

  
   property prop_stable_write_data;
      @(cb) disable iff(!RESETn)
	($changed(PADDR) && PWRITE)  |=> ($stable(PADDR) until $rose(PREADY) ##0 $stable(PADDR));
      
   endproperty // prop_stable_addr_and_write_data

   assert property(prop_stable_write_data);

   /*
   property prop_stable_write_addr;
      @(posedge PCLK) disable iff(!RESETn)
	(((`ADDR_PHASE) && PWRITE)  || (`ACCESS_PHASE && PWRITE && !PREADY) |=> ($stable(PADDR) &&PREADY));
   endproperty // prop_stable_addr_and_write_data

   assert property(prop_stable_write_addr);
   
   property prop_stable_read_addr;
      @(posedge PCLK) disable iff(!RESETn)
	(((`ADDR_PHASE) && !PWRITE)  || (`ACCESS_PHASE && !PWRITE && !PREADY) |-> $stable(PADDR));
   endproperty // prop_stable_addr_and_write_data

   assert property(prop_stable_read_addr);


   */
   
`endif
