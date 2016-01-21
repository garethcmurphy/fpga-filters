/*-------------*-----codecout----------*------------------*/
module filter (clock, reset, mclk, sclk, lrck, seq, l_codec_to_fpga, r_codec_to_fpga ,l_fpga_to_codec , r_fpga_to_codec) ;
parameter COUNTER_DEPTH1 = 7'd10 ;
parameter ARRAY_WIDTH = 7'd20;
parameter COEFF_WIDTH = 10'd8;
parameter divisor = 2'd11;
parameter coeff1 = 8'h06 ;
parameter coeff2 = 8'h12 ; 
parameter coeff3 = 8'h25 ; //
parameter coeff4 = 8'h06 ;
parameter coeff5 = 8'h81 ;
parameter coeff6 = 8'h5B ; 
parameter coeff7 = 8'hEE ; //
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
*/
input clock, reset, mclk, sclk, lrck ;
input [COUNTER_DEPTH1:0] seq ;
input [ARRAY_WIDTH-1:0] l_codec_to_fpga , r_codec_to_fpga ;
output [ARRAY_WIDTH-1:0] l_fpga_to_codec , r_fpga_to_codec ;

/*
assign r_fpga_to_codec = r_codec_to_fpga ;
*/


reg [ARRAY_WIDTH:0] l_tap1, l_tap2, l_tap3, l_tap4 ;
reg [ARRAY_WIDTH:0] x_sample1, x_sample2, x_sample3 , x_sample4 ;
reg [ARRAY_WIDTH:0] x_sample5, x_sample6, x_sample7 , x_sample8 ;
reg [19:0] l_factor1, l_factor2, l_factor3 , l_factor4;
reg [19:0] r_factor1, r_factor2, r_factor3 , r_factor4 ,temp ;
reg [19:0] r_factor5, r_factor6, r_factor7 , r_factor8 ;
reg [ARRAY_WIDTH-1:0] l_fpga_to_codec , r_fpga_to_codec ;
reg [19:0] l_temp , y_sample1;
reg [19:0] y_sample2 , y_sample3 ;

mult_tc            m1 (coeff1, x_sample1[19:12] ,r_factor1[19:4]);
mult_tc            m2 (coeff2, x_sample2[19:12] ,r_factor2[19:4]);
mult_tc            m3 (coeff3, x_sample3[19:12] ,r_factor3[19:4]);
mult_tc            m4 (coeff4, x_sample4[19:12] ,r_factor4[19:4]);
mult_tc            m5 (coeff5, y_sample1[19:12] ,r_factor5[19:4]);
mult_tc            m6 (coeff6, y_sample2[19:12] ,r_factor6[19:4]);
mult_tc            m7 (coeff7, y_sample3[19:12] ,r_factor7[19:4]);
//mult_tc            m8 (coeff1, x_sample8[19:12] ,r_factor8[19:4]);
//mult_tc            m9 (coeff7, y_sample[19:12] ,y_sample2[19:4]);
//mult_tc            m10 (coeff8, y_sample2[19:12] ,y_sample3[19:4]);
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
	x_sample1 <= {r_codec_to_fpga[ARRAY_WIDTH-2] ,r_codec_to_fpga[ARRAY_WIDTH-2] , r_codec_to_fpga[ARRAY_WIDTH-2:0]}	;
	x_sample2 <= x_sample1 	;
	x_sample3 <= x_sample2 	;
	x_sample4 <= x_sample3	;
	//x_sample5 <= x_sample4 	;
	//x_sample6 <= x_sample5 	;
	//x_sample7 <= x_sample6	;
	//x_sample8 <= x_sample7	;
	
	y_sample1  <= ( (r_factor1  + r_factor2)  + (r_factor3  + r_factor4) );//+ (r_factor5  + r_factor6)  + (r_factor7  + r_factor8)) ;
	y_sample2 <= y_sample1;
	y_sample3 <= y_sample2;	
	r_fpga_to_codec [ARRAY_WIDTH-1:0] <=   {r_factor5 [19:0] } + {r_factor6 [19:0] }  + {r_factor7 [19:0] };
end //end of reset
end // end of always



endmodule 

