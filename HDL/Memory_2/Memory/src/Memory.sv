 

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
module Decoder(input logic enable, [2:0]adr, output logic [7:0]sel);
	//And not_sleep with all the adr-lines and the output from the first and gate
	wire [2:0]in;

	//Theese extra and gates make sure that the address is set to 000 if
	//the not_sleep signal is high. The latter gate make sure the output there is also 0.
	and(in[0], adr[0], enable);
	and(in[1], adr[1], enable);
	and(in[2], adr[2], enable);
	
	wire a0_not, a1_not, a2_not, first_and;
	//The next to gates make sure that 000 appears on the output of not_sleep is low.
	not(a0_not, in[0]);
	not(a1_not, in[1]);
	not(a2_not, in[2]);
	and(first_and, a0_not, a1_not, a2_not);
	//Normal decoder gates below.
	and(sel[0], first_and, enable);
	and(sel[1], in[0], a1_not, a2_not);
	and(sel[2], a0_not, in[1], a2_not);
	and(sel[3], in[0], in[1], a2_not);
	and(sel[4], a0_not, a1_not, in[2]);
	and(sel[5], in[0], a1_not, in[2]);
	and(sel[6], a0_not, in[1], in[2]);
	and(sel[7], in[0], in[1], in[2]);
endmodule

//Memory matrix with 8 inputs, select and outputs and one read/write (rw)
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
	//and finally tie the outputs of the two or gates in the same column together.
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

//Declare a FlipFlop to reduce clutter in the code
module FlipFlop(input logic clk, input logic d, output logic q);
	always_ff @(posedge clk) begin
		q <= d;
	end
endmodule

module FSM(input logic read, write, clk, output logic rw, enable);
	wire rw_not, rd, wd, rq, wq, wq_not;
	//The read and write are nanded together
	nand(rw_not, read, write);
	//This is combined with read and write to get the correct input to the flipflops
	and(rd, rw_not, read);
	and(wd, rw_not, write);
	//Instantiate the flipflops
	FlipFlop my_rd(.clk(clk),.d(rd),.q(rq));
	FlipFlop my_wd(.clk(clk),.d(wd),.q(wq));
	//The output from the flipflops are combined to get the correct output in the 
	//different states
	not(wq_not, wq);
	//Make the output rw
	and(rw, rq, wq_not);
	//Make the enable signal
	or(enable, rq, wq);
endmodule

module CombinedSystem(input logic read, write, clk, [2:0]adr, [7:0]inputs, output logic [7:0]outputs);
	wire rw, enable;
	wire [7:0]sel;

	//Instantiate the FSM
	FSM my_fsm(.read(read),.write(write),.clk(clk),.rw(rw),.enable(enable));
	//Instantiate the decoder
	Decoder my_decoder(.adr(adr),.sel(sel),.enable(enable));
	//Instantiate the memory module
	MemoryModule my_memory(.inputs(inputs),.sel(sel),.rw(rw),.outputs(outputs));
endmodule

//######################################################################
//########				Testbenches below this point			########
//######################################################################

`timescale 1ns/1ps

//Writes "Sindre" in ASCII to the memory and reads it out line by line
module CombinedSystem_tb();
	logic [7:0]inputs, outputs;
	logic read, write, clk;
	logic [2:0]adr;
	always #5ns begin
		clk = ~clk;
	end
	//Instantiate the combined system
	CombinedSystem my_system(.read(read),.write(write),.clk(clk),.adr(adr),.inputs(inputs),.outputs(outputs));

	initial begin
		clk = 0;
		//Write "S" to the first row in the memory and read it out
		inputs = 8'b01010011;
		adr = 3'b000;
		read = 1'b0;
		write = 1'b1;
		#11ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "i" to the second row and read it out
		inputs = 8'b01101001;
		adr = 3'b001;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "n" to the third row and read it out
		inputs = 8'b01101110;
		adr = 3'b010;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "d" to the fourth row and read it out
		inputs = 8'b01100100;
		adr = 3'b011;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "r" to the fifth row and read it out
		inputs = 8'b01110010;
		adr = 3'b100;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "e" to the sixth row and read it out
		inputs = 8'b01100101;
		adr = 3'b101;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the first row again
		adr = 3'b000;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the second row again
		adr = 3'b001;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the third row again
		adr = 3'b010;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//#########					#########
		//REPEAT THE WHOLE THING AS A TEST
		//#########					#########
		//Write "S" to the first row in the memory and read it out
		inputs = 8'b01010011;
		adr = 3'b000;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "i" to the second row and read it out
		inputs = 8'b01101001;
		adr = 3'b001;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "n" to the third row and read it out
		inputs = 8'b01101110;
		adr = 3'b010;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "d" to the fourth row and read it out
		inputs = 8'b01100100;
		adr = 3'b011;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "r" to the fifth row and read it out
		inputs = 8'b01110010;
		adr = 3'b100;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write "e" to the sixth row and read it out
		inputs = 8'b01100101;
		adr = 3'b101;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the first row again
		adr = 3'b000;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the second row again
		adr = 3'b001;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the third row again
		adr = 3'b010;
		read = 1'b1;
		write = 1'b0;
		#10ns;
	end
endmodule


module CombinedSystem_tb_2();
	logic [7:0]inputs, outputs;
	logic read, write, clk;
	logic [2:0]adr;
	always #5ns begin
		clk = ~clk;
	end
	//Instantiate the combined system
	CombinedSystem my_system(.read(read),.write(write),.clk(clk),.adr(adr),.inputs(inputs),.outputs(outputs));

	initial begin
		clk = 0;
		//write 1 to the first row in the memory and read it out
		inputs = 8'b00000001;
		adr = 3'b000;
		read = 1'b0;
		write = 1'b1;
		#11ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write 2 to the second row and read it out
		inputs = 8'b00000010;
		adr = 3'b001;
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the first row again
		inputs = 8'b00011001;
		adr = 3'b000;
		read = 1'b1;
		write = 1'b0;
		#10ns;
	end
endmodule

module Memory_tb();
	logic [7:0]inputs, outputs;
	logic rw, enable;
	logic [2:0]adr;
	wire [7:0]sel;

	//Instantiate the decoder
	Decoder my_decoder(.enable(enable),.adr(adr),.sel(sel));

	//Instantiate the memory module
	MemoryModule my_memory(.inputs(inputs),.sel(sel),.rw(rw),.outputs(outputs));
	initial begin
		//write 1 to the first row in the memory and read it out
		enable = 1'b1;
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

//Testbench for the FSM
module FSM_tb();
	logic read, write, clk, rw, enable;
	//Set the timescale to ns

	always #5ns begin
		clk = ~clk;
	end
	//Instantiate the FSM
	FSM my_fsm(.read(read),.write(write),.clk(clk),.rw(rw),.enable(enable));
	initial begin
		clk = 0;
		//write 1 to the first row in the memory and read it out
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//Then write 2 to the second row and read it out
		read = 1'b0;
		write = 1'b1;
		#10ns;
		read = 1'b1;
		write = 1'b0;
		#10ns;
		//The read from the first row again
		read = 1'b0;
		write = 1'b0;
		#10ns;
		//Try the illegal state
		read = 1'b1;
		write = 1'b1;
		#10ns;
		//#100ns;
	end
endmodule

//Testbench for the Decoder
module Decoder_tb();
	logic [2:0]adr;
	logic [7:0]sel;
	logic enable;
	//Instantiate the decoder
	Decoder my_decoder(.enable(enable),.adr(adr),.sel(sel));
	initial begin
		//write 1 to the first row in the memory and read it out
		enable = 1'b1;
		adr = 3'b000;
		#10;
		adr = 3'b001;
		#10;
		adr = 3'b010;
		#10;
		adr = 3'b011;
		#10;
		adr = 3'b100;
		#10;
		adr = 3'b101;
		#10;
		adr = 3'b110;
		#10;
		adr = 3'b111;
		#10;
		enable = 1'b0;
		adr = 3'b000;
		#10;
		adr = 3'b001;
		#10;
		adr = 3'b010;
		#10;
		adr = 3'b011;
		#10;
		adr = 3'b100;
		#10;
		adr = 3'b101;
		#10;
		adr = 3'b110;
		#10;
		adr = 3'b111;
		#10;
	end
endmodule