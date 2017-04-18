module pipeimem(addr,inst,memclock);
	input  [31:0] addr;
	input memclock;
   output [31:0] inst;
   
    
   
   lpm_rom_irom irom (addr[7:2],memclock,inst); 
				
endmodule