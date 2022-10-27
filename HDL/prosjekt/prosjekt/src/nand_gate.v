module NandGate(y, a, b);
	input wire a, b;
	output wire y;
	and(y,a,b);
endmodule

module tb_nand;
	reg ina = 1'b1; 
	reg inb = 1'b1;
	wire out;
	NandGate myNand(.y(out),.a(ina),.b(inb));
	localparam period = 20;  
	initial begin
		#10ns;
		ina = 1'b0;
		inb = 1'b1;
		#10ns;
		ina = 1'b0;
		inb = 1'b0;
		#10ns;
		ina = 1'b1;
		#10ns;
		#30ns;
	end
endmodule						 