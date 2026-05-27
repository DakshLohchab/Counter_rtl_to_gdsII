`timescale 1ns/1ps
module tb_counter;
	reg clk;
	reg rst;
	wire [3:0] count;
	counter uut(
		.clk(clk),.rst(rst),.count(count));
	always #5 clk = ~clk;
	initial begin
		clk = 0;
		rst = 0;
		#20
		rst = 1;
		#200
		$finish;
	end
	initial begin
		$monitor("Time=%0t rst=%b counter=%d",$time,rst,count);
	end
endmodule
