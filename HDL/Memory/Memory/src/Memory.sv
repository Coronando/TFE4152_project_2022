 

//SR-latch	   
module SrLatch(input logic set, reset, output logic q, q_not);	
	nand(q, set, q_not);
	nand(q_not, reset, q);
endmodule

//Bitcell as described in the paper
module Bitcell(input logic in, sel, read, output logic out);
	wire set, reset,enable, in_not, q, q_not, write;
	not(write, read);
	and(enable, write, sel);
	nand(set, enable, in);
	nand(reset, enable, set);
	SrLatch my_latch(.set(set),.reset(reset),.q(q),.q_not(q_not));
	and(out, q, sel, read);
endmodule

//3 to 8 decoder
//The decoder outputs a logic high on the given adress if as long as 
//not_sleep is HIGH, else it outputs only zeros and no words are selected.
module Decoder(input logic [2:0]adr, output logic not_sleep, [7:0]sel);
	//And not_sleep with all the adr-lines and the output from the first and gate
	wire [2:0]in;

	//Theese extra and gates make sure that the address is set to 000 if
	//the not_sleep signal is high. The latter gate make sure the output there is also 0.
	and(in[0], adr[0], not_sleep);
	and(in[1], adr[1], not_sleep);
	and(in[2], adr[2], not_sleep);
	
	wire a0_not, a1_not, a2_not, first_and;
	not(a0_not, in[0]);
	not(a1_not, in[1]);
	not(a2_not, in[2]);
	//The next to gates make sure that 000 appears on the output of not_sleep is low.
	and(first_and, a0_not, a1_not, a2_not);
	and(sel[0], first_and, not_sleep)
	and(sel[1], in[0], a1_not, a2_not);
	and(sel[2], a0_not, in[1], a2_not);
	and(sel[3], in[0], in[1], a2_not);
	and(sel[4], a0_not, a1_not, in[2]);
	and(sel[5], in[0], a1_not, in[2]);
	and(sel[6], a0_not, in[1], in[2]);
	and(sel[7], in[0], in[1], in[2]);
endmodule

//Memory matrix with 8 inputs and 8 outputs, read/write and 
module MemoryModule(input logic rw, [7:0]inputs, [7:0]sel, output logic [7:0]outputs);
	wire [15:0]output_combiner;
	wire [63:0]out;

	//Declare the length and width of the memory
	localparam int width = 8;
	localparam int height = 8;
	//Generate the bitcell matrix with a generate statement
	//Generates a 8x8 matrix of bitcells with 1 input for each word,
	//and 1 output for each cell.
	//Also tie 4 and 4 of the outputs in each column from the bitcells to or gates.
	generate
		for(genvar i = 0; i < width; i++) begin
			for(genvar j = 0; j < height; j++) begin
				Bitcell my_bitcell(.in(inputs[i]),.sel(sel[j]),.read(rw),.out(out[i*height+j]));
			end
			or(output_combiner[i*2], out[i*height], out[i*height+1], out[i*height+2], out[i*height+3]);
			or(output_combiner[i*2+1], out[i*height+4], out[i*height+5], out[i*height+6], out[i*height+7]);
			//Combine the two outputs from each column into one output
			or(outputs[i], output_combiner[i*2], output_combiner[i*2+1]);
		end
	endgenerate
endmodule




module Memory_tb();
	logic [7:0]inputs, outputs;
	logic rw, not_sleep;
	logic [2:0]adr;
	wire [7:0]sel;

	//Instantiate the decoder
	Decoder my_decoder(.adr(adr),.sel(sel));

	//Instantiate the memory module
	MemoryModule my_memory(.inputs(inputs),.sel(sel),.rw(rw),.outputs(outputs));
	initial begin
		//write 1 to the first row in the memory and read it out
		not_sleep = 1'b1;
		inputs = 8'b00000001;
		adr = 3'b000;
		rw = 1'b0;
		#10;
		rw = 1'b1;
		#10;
		//Then write 2 to the second row and read it out
		inputs = 8'b00000010;
		adr = 3'b001;
		rw = 1'b0;
		#10;
		rw = 1'b1;
		#10;
		//The read from the first row again
		inputs = 8'b00011001;
		adr = 3'b000;
		rw = 1'b1;
		#10;

	end
endmodule

//Declare a FlipFlop to reduce clutter in the code
module FlipFlop(input logic clk, input logic d, output logic q);
	always_ff @(posedge clk) begin
		q <= d;
	end
endmodule

module FSM(input logic rw, enable, clock, [2:0]adr, [7:0]i, output logic [7:0]o);
	//Instantiate the decoder
	Decoder my_decoder(.adr(adr),.sel(sel));
	//Instantiate the memory module
	MemoryModule my_memory(.inputs(inputs),.sel(sel),.rw(rw),.outputs(outputs));

	//Gate logic 

	//Two flipflops to keep track of the state
	FlipFlop f1(.clk(clock),.d(state2),.q(state1));
	FlipFlop f2(.clk(clock),.d(state3),.q(state2));

endmodule