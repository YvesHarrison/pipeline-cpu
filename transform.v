module transform(num,num_high,num_low);
	input [7:0] num;
	output [6:0]	num_high,num_low;

	reg [3:0] high;
	reg [3:0] low;
	reg [7:0] tmp;
	
	always@(*)
		begin
			low=0;
			high=0;
			tmp=num;
			if(tmp>=10)
				begin
					high=high+1;
					tmp=tmp-10;
				end
			if(tmp>=10)
				begin
					high=high+1;
					tmp=tmp-10;
				end
			if(tmp>=10)
				begin
					high=high+1;
					tmp=tmp-10;
				end
			if(tmp>=10)
				begin
					high=high+1;
					tmp=tmp-10;
				end
			if(tmp>=10)
				begin
					high=high+1;
					tmp=tmp-10;
				end
			if(tmp>=10)
				begin
					high=high+1;
					tmp=tmp-10;
				end
			low=tmp;
		end
	
	sevenseg	show_num_high(high,num_high);
	sevenseg	show_num_low(low,num_low);
	
endmodule