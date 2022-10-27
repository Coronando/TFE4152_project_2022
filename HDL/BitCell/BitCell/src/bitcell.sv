/*module bitcell(input logic in, sel, read, output logic out);
	wire set, reset, in_not, q, q_not, write, q_and_read;
	not(write, read);
	not(in_not, in);
	nand(reset, sel, in_not, read);
	nand(set, sel, in, read);
	SrLatch my_latch(.set(set),.reset(reset),.q(q),.q_not(q_not));
	and(out, q, sel, read);
endmodule*/
module bitcell(input logic in, sel, read, output logic out);
	wire set, reset,enable, in_not, q, q_not, write;
	not(write, read);
	and(enable, write, sel);
	nand(set, enable, in);
	nand(reset, enable, set);
	SrLatch my_latch(.set(set),.reset(reset),.q(q),.q_not(q_not));
	and(out, q, sel, read);
endmodule

module simple_bitcell(input logic in, sel, write, output logic out, out_not);
	wire set, reset, in_not;
	not(in_not, in);
	and(reset, sel, in_not);
	and(set, sel, in);
	SrLatch my_latch(.set(set),.reset(reset),.q(out_not),.q_not(out));
endmodule	

module tb_bitcell;
	logic in, sel, read, out;
	bitcell my_bitcell(.in(in),.sel(sel),.read(read),.out(out));
	//simple_bitcell my_bitcell(.in(in),.sel(sel),.write(write),.out(out),.out_not(out_not));
	initial begin
		//Test that the read works as expected.
		/*in = 0;
		sel = 1;
		read = 1;
		#5ns;
		in = 1;
		#5ns;
		read = 0;
		#5ns;
		read = 1;
		#5ns;
		in = 0;
		#5ns;
		read = 0;
		#5ns;
		read = 1;
		#5ns;
		in = 1;
		#5ns;
		in = 0;
		#5ns;*/
		//Test that the select works as expected.
		in = 0;
		sel = 0;
		read = 1;
		#5ns;
		in = 1;
		#5ns;
		read = 0;
		#5ns;
		read = 1;
		#5ns;
		in = 0;
		#5ns;
		read = 0;
		#5ns;
		read = 1;
		#5ns;
		in = 1;
		#5ns;
		in = 0;
		#5ns;
		
		
		/*in = 0;
		sel = 1;
		read = 1;
		#10ns;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		in = 1;
		#10ns;
		in = 1;
		#10ns;
		sel = 0;
		in = 0;
		#10ns;
		in = 0;
		#10ns;
		in = 0;
		#10ns;
		in = 0;
		sel = 1;
		read = 0;
		#10ns;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		sel = 0;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		in = 1;
		#10ns;
		in = 0;
		/*#10ns;
		write = 0;
		sel = 0;
		in = 0;
		#10ns;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		in = 1;
		#10ns;*/
		
		
	end
endmodule
	
