module	pipemem(we,addr,datain,clock,mem_clk,dmem_clk,dataout,plus1,plus2,plus1_high,plus2_high,total_high,plus1_low,plus2_low,total_low,lcd);
	input  [31:0]  addr;
   input  [31:0]  datain;
   input	 [4:0]	plus1;
	input	 [4:0]	plus2;
   input          we,clock,mem_clk;
   output [31:0]  dataout;
   input          dmem_clk;
   output [6:0]   plus1_high,plus2_high,total_high,plus1_low,plus2_low,total_low;
   wire           dmem_clk;    
   wire           write_enable; 
   assign         write_enable = we & ~clock; 
   output [9:0] lcd;

	reg[7:0] lcdreg [3:0];
	wire [7:0]	sw1;
	wire [7:0]	sw2;
	wire [7:0]	in_out;
   lpm_ram_dq_dram  dram(addr[6:2],mem_clk,datain,write_enable&(!addr[7]),in_out);
	get_switch	plus_number1(sw1,plus1);
	get_switch	plus_number2(sw2,plus2);
	assign lcd[4:0]=datain;

	
	transform	plus1_show(lcdreg[1],plus1_high,plus1_low);
	transform	plus2_show(lcdreg[2],plus2_high,plus2_low);
	transform	total_show(lcdreg[3],total_high,total_low);
	
	wire	isLcdreg;
	assign isLcdreg=addr[7]&(addr[3]|addr[4]);
	
	always@(posedge mem_clk)
		if(write_enable && isLcdreg)
			lcdreg[addr[4:3]]=datain;

	assign	dataout=({32{~addr[7]}}&in_out)|({32{addr[7:0]==8'b10000000}}&sw1)|({32{addr[7:0]==8'b10000100}}&sw2)|({32{isLcdreg}}&lcdreg[addr[4:3]]);
endmodule