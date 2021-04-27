`include "RTLDefines.sv"
`include "interface.sv"
`include "../Top/APBPackage.sv"


module APB_dummy (
    input   bit   PCLK,
    input   bit   PRESET,
    input   logic PENABLE,
    input   logic PSEL,
    input   logic PWRITE,
    input   logic [15:0] PADDR,
    input   logic [15:0] PWDATA,
    output  logic [15:0] PRDATA,
    output  logic PSLVERR,
    output  logic PREADY
);

logic [15:0] memArray[256];
logic PREADY_NEXT;

// This code reports every active bus cycle to the console.
initial begin : cycle_reporting
    int clocks;
    for (int i = 0; i < 1024; i++) begin
        memArray[i] = 16'b0;
    end
    PREADY_NEXT = 0;
    PREADY = 0;
    PSLVERR = 1'b0;
    forever @(posedge PCLK) begin
        clocks++;
        PREADY <= 1'b0;
        if (!PRESET) begin
            $display("Detected reset!\n\n");
        end else begin
            // Handle second cycle of the phase.
            if (PSEL && PENABLE && PWRITE && PREADY_NEXT) begin // it's a write
                $display("--------\nAPB write at clocks %0d/%0d, time=%0d:",
                    clocks-1, clocks, $time);
                $display("  A='h%h, D='h%h, ERROR='h%h", PADDR, PWDATA, PSLVERR);
                // PADDR = 1 is a read_only shadow register of PADDR = 0
                if (PADDR == 1 || PADDR == 0) begin
                    if (PADDR == 0) begin
                        $display("Detected write to WO register!\n");
                        memArray[0] <= PWDATA;
                        memArray[1] <= (PWDATA ^ 16'hFFFF);
                    end
                    if (PADDR == 1) begin
                        $display("Detected write to RO register!\n");
                        PSLVERR = 1'b1;
                    end
                end else begin
                    memArray[PADDR] <= PWDATA;
                end
                PREADY_NEXT <= 1'b0;
                PREADY <= 1'b1;
            end else if (PSEL && PENABLE && !PWRITE && PREADY_NEXT) begin // it's a read
                // second clock of read, report it
                $display("--------\nAPB read at clocks %0d/%0d, time=%0d:",
                    clocks-1, clocks, $time);
                $display("  A='h%h, D='h%h, ERROR='h%h", PADDR, memArray[PADDR], PSLVERR);
                // PADDR = 1 is a read_only shadow register of PADDR = 0
                if (PADDR == 1 || PADDR == 0) begin
                    if (PADDR == 1) begin
                        $display("Detected read to RO register!\n");
                        PRDATA <= memArray[1];
                    end
                    if (PADDR == 0) begin
                        $display("Detected read to WO register!\n");
                        PSLVERR = 1'b1;
                        PRDATA <= $urandom;
                    end
                end else begin
                    PRDATA <= memArray[PADDR];
                end
                PREADY_NEXT <= 1'b0;
                PREADY <= 1'b1;
            end

            // Handle first cycle of the transfer.
            if (PSEL && !PENABLE) begin
                PREADY_NEXT<= $urandom_range(0,1);
            end

            // Handle wait cycle of the transfer.
            if (PSEL && PENABLE && !PREADY_NEXT) begin
                PREADY_NEXT<= $urandom_range(0,1);
            end

            // Handle error condition (only for illustration purpose)
            if ((PADDR > 128) && PSEL && PENABLE && PREADY_NEXT) begin
                PSLVERR = 1'b1;
            end else begin
                PSLVERR = 1'b0;
            end

            // Handle the registers (to test RAL methods)
            // Assume we have 2 registers at addresses 0 to 1.
            //if ((PADDR < 2) && PSEL && PENABLE && PREADY_NEXT) begin
                //$display("Detected regsiter operation!\n");
            //end else begin
                //$display("Detected memory operation!\n");
            //end
        end // reset
    end
end : cycle_reporting

endmodule : APB_dummy


module apb_top_testbench;
   import uvm_pkg::*;
   import APBPackage::*;
   
   reg clk;
   reg RESETn=1;
Interface vif(clk, RESETn);

   initial clk = 0;

   always #5  clk = ~clk;

   APB_dummy dut (.PCLK(clk), 
		  .PRESET(RESETn),
		  .PENABLE(vif.PENABLE), 
		  .PRDATA(vif.PRDATA), 
		  .PWDATA(vif.PWDATA), 
		  .PADDR(vif.PADDR),
		  .PSEL(vif.PSEL),
		  .PWRITE(vif.PWRITE),
		  .PREADY(vif.PREADY),
		  .PSLVERR(vif.PSLVERR)
		  );
   
		  
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

