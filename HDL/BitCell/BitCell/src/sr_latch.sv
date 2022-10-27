//Inverting latch, when set is 1, then q will be 0,
//We change this around because we feel	its easier to work with
module SrLatch(input logic set, reset, output logic q, q_not);	
	nand(q, set, q_not);
	nand(q_not, reset, q);
endmodule

module sr_latch_tb;
	logic in, reset, out, out_not;
	SrLatch my_latch(.set(in),.reset(reset),.q(out),.q_not(out_not));
	initial begin;
		reset = 0;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		in = 0;
		#10ns;
		in = 1;
		#10ns;
		in = 1;
		#10ns;
		in = 0;
		#10ns;
		reset = 1;
		#10ns;
		in = 0;
		#10ns;
		in = 1;
	end 
endmodule