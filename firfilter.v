/*-------------*-----codecout----------*------------------*/

module filter (clock, reset, mclk, sclk, lrck, seq, l_codec_to_fpga, r_codec_to_fpga ,l_fpga_to_codec , r_fpga_to_codec) ;
parameter COUNTER_DEPTH1 = 7'd10 ;
parameter ARRAY_WIDTH = 7'd20;
parameter COEFF_WIDTH = 10'd8;
parameter divisor = 2'd11;
parameter coeff1 = 8'hF4 ;
parameter coeff2 = 8'hFC ; 
parameter coeff3 = 8'h18 ; //
parameter coeff4 = 8'h33 ;
//parameter coeff5 = 8'h ;
//parameter coeff6 = 8'h ; 
//parameter coeff7 = 8'h ; //
//parameter coeff8 = 8'h ;
/*
0B 0F 13 14 14 13 0F 0B  set 1
04 0F 19 20 20 19 0F 04 		Set 2
10 ED EB 16 16 EB ED 10    Bandpass
F6 F7 15 38									Lowpass1
FF FE 0E 35									Lowpass2
00 FE 0D 35									Lowpass3
F8 O7 CA 2A									Hipass1
FF 02 DD 28									Hipass2
00 01 DF 28
F4 FC 18 33									Lowpass4 

*/
input clock, reset, mclk, sclk, lrck ;
input [COUNTER_DEPTH1:0] seq ;
input [ARRAY_WIDTH-1:0] l_codec_to_fpga , r_codec_to_fpga ;
output [ARRAY_WIDTH-1:0] l_fpga_to_codec , r_fpga_to_codec ;
reg [ARRAY_WIDTH:0] l_tap1, l_tap2, l_tap3, l_tap4 ;
reg [ARRAY_WIDTH:0] r_tap1, r_tap2, r_tap3 , r_tap4 ;
reg [ARRAY_WIDTH:0] r_tap5, r_tap6, r_tap7 , r_tap8 ;
reg [19:0] l_factor1, l_factor2, l_factor3 , l_factor4;
reg [19:0] r_factor1, r_factor2, r_factor3 , r_factor4 ,temp ;
reg [19:0] r_factor5, r_factor6, r_factor7 , r_factor8 ;
reg [ARRAY_WIDTH-1:0] l_fpga_to_codec , r_fpga_to_codec ;
reg [19:0] l_temp , r_temp;
reg [19:0] r_temp2 , r_temp3 ;
//twos_comp_multiply m1 (clock, reset, mclk, sclk, lrck, seq, r_tap1 , .op2(coeff1) , .factor(r_factor1) ) ;
mult_tc            m1 (coeff1, r_tap1[19:12] ,r_factor1[19:4]);
mult_tc            m2 (coeff2, r_tap2[19:12] ,r_factor2[19:4]);
mult_tc            m3 (coeff3, r_tap3[19:12] ,r_factor3[19:4]);
mult_tc            m4 (coeff4, r_tap4[19:12] ,r_factor4[19:4]);
mult_tc            m5 (coeff4, r_tap5[19:12] ,r_factor5[19:4]);
mult_tc            m6 (coeff3, r_tap6[19:12] ,r_factor6[19:4]);
mult_tc            m7 (coeff2, r_tap7[19:12] ,r_factor7[19:4]);
mult_tc            m8 (coeff1, r_tap8[19:12] ,r_factor8[19:4]);
//mult_tc            m9 (coeff7, r_temp[19:12] ,r_temp2[19:4]);
//mult_tc            m10 (coeff8, r_temp2[19:12] ,r_temp3[19:4]);
always @ (negedge lrck)
begin
if (reset == 1'b1 )
begin
	l_fpga_to_codec [ARRAY_WIDTH-1:0] <=  0 ;// 
end //end of reset
end // end of always 
always @ (posedge lrck)
begin
if (reset )
begin
	r_tap1 <= {r_codec_to_fpga[ARRAY_WIDTH-2] ,r_codec_to_fpga[ARRAY_WIDTH-2] , r_codec_to_fpga[ARRAY_WIDTH-2:0]}	;
	r_tap2 <= r_tap1 	;
	r_tap3 <= r_tap2 	;
	r_tap4 <= r_tap3	;
	r_tap5 <= r_tap4 	;
	r_tap6 <= r_tap5 	;
	r_tap7 <= r_tap6	;
	r_tap8 <= r_tap7	;
	
	r_temp  <= ( (r_factor1  + r_factor2)  + (r_factor3  + r_factor4) + (r_factor5  + r_factor6)  + (r_factor7  + r_factor8)) ;
	//r_temp2 <= r_temp;
	r_fpga_to_codec [ARRAY_WIDTH-1:0] <=   {r_temp [19:0] };// + {r_temp2 [19:0] }  + {r_temp3 [19:0] };
end //end of reset
end // end of always
endmodule 


