module piplelinedcpu(cpu_clock,resetn,pc,inst,ealu,malu,walu,plus1,plus2,plus1_high,plus2_high,total_high,plus1_low,plus2_low,total_low,lcd);
	input cpu_clock,resetn;
	output [31:0] pc,inst,ealu,malu,walu;
	wire [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,da,db,dimm,ea,eb,eimm;
	wire [31:0] epc4,mb,mmo,wmo,wdi;
	wire [4:0] drn,ern0,ern,mrn,wrn;
	wire [3:0] daluc,ealuc;
	wire [1:0] pcsource;
	reg clock,memclock;
	wire	wpcir;
	wire  dwreg,dm2reg,dwmem,daluimm,dshift,djal;
	wire	ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
	wire	mwreg,mm2reg,mwmem;
	wire	wwreg,wm2reg;
	
	reg cnt1=0;
	
	input	[4:0] plus1,plus2;
	output [6:0]   plus1_high,plus2_high,total_high,plus1_low,plus2_low,total_low;
	output [9:0] lcd;
	always@(posedge cpu_clock)
		begin
			if(cnt1>=1)
				begin
					clock=~clock;
					cnt1=0;
				end
			else
				begin
					cnt1=cnt1+1'b1;
					memclock<=~memclock;
				end
		end

	
	pipepc prog_cnt (npc,wpcir,clock,resetn,pc);
	
	pipeif if_stage (pcsource,pc,bpc,da,jpc,npc,pc4,ins,memclock);
	
	pipeir inst_reg (pc4,ins,wpcir,clock,resetn,dpc4,inst);
	
	pipeid id_stage (mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,wrn,wdi,ealu,malu,
						  mmo,wwreg,clock,resetn,bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,djal);
						  
	pipedereg de_reg (dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,djal,dpc4,clock,resetn,ewreg,em2reg,ewmem,ealuc,ealuimm,ea,eb,eimm,ern0,
						   eshift,ejal,epc4);
							
	pipeexe exe_stage (ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,ejal,ern,ealu);
	
	pipeemreg em_reg (ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn,mwreg,mm2reg,mwmem,malu,mb,mrn);
	
	pipemem mem_stage (mwmem,malu,mb,clock,memclock,memclock,mmo,plus1,plus2,plus1_high,plus2_high,total_high,plus1_low,plus2_low,total_low,lcd);
	
	pipemwreg mw_reg (mwreg,mm2reg,mmo,malu,mrn,clock,resetn,wwreg,wm2reg,wmo,walu,wrn);
	
	mux2x32 wb_stage (walu,wmo,wm2reg,wdi);

endmodule