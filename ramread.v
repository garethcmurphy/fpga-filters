module interface(clock , reset,  mclk, sclk, lrck, seq , sdin , l_fpga_to_codec , r_fpga_to_codec ,l_codec_to_fpga , r_codec_to_fpga, sdout , data , address , test_sdout) ;
parameter ARRAY_SIZE = 6'd20 ;
parameter SHIFT_REG= 6'd32 ;
parameter COUNTER_DEPTH1 = 7'd10 ;
input [ARRAY_SIZE-1:0] l_fpga_to_codec , r_fpga_to_codec ;
input clock, reset, mclk, sclk, lrck ;
input [COUNTER_DEPTH1:0] seq ;
input sdout ;
input [7:0] data ;
output [14:0] address ;
reg [14:0] address ;
output sdin ;
output [ARRAY_SIZE-1:0] l_codec_to_fpga , r_codec_to_fpga ;
reg [ARRAY_SIZE-1:0] l_codec_to_fpga , r_codec_to_fpga ;
output test_sdout ;
reg sdin , test_sdout;
reg	[SHIFT_REG-1:0] l_in_shift , r_in_shift  ;
reg [SHIFT_REG-1:0] l_out_shift, r_out_shift ;
reg [SHIFT_REG-1:0] l_out_shift_int, r_out_shift_int ;


always @ (negedge sclk )
begin
	if (reset == 1'b1)
	begin
		if (seq <11'h1D8)
		begin
			if (lrck==0)
			begin
				sdin <= l_out_shift_int[31];
				l_out_shift_int[31:0] <= { l_out_shift_int[30:0] , l_out_shift_int[31] };
			end
			else if ( lrck == 1)
			begin
				sdin <= r_out_shift_int[31];
				r_out_shift_int[31:0] <= { r_out_shift_int[30:0] , r_out_shift_int[31] };
			end
		end
		else if (seq > 11'h1D8)
		begin
			l_out_shift [30:11]							<=	l_fpga_to_codec	[ARRAY_SIZE-1:0]	;
		r_out_shift [30:11]							<=	r_fpga_to_codec	[ARRAY_SIZE-1:0]	; 
		l_out_shift_int[31:0]<=l_out_shift[31:0];
		r_out_shift_int[31:0]<=r_out_shift[31:0];
		end
	end
end
always @ (posedge lrck)
begin
		// convert to two's complement 
		l_codec_to_fpga[ARRAY_SIZE-1:0]	<=	{ (data[7:0]) , 12'd0 };
end
always @ (negedge lrck)
begin
		address <= address + 1'b1 ;
		r_codec_to_fpga[ARRAY_SIZE-1:0]	<=	{ (data[7:0]) , 12'd0 };
end
endmodule 
