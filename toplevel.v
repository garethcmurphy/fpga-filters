module toplevel (reset , clock, mclk, sclk, lrck, sdin , sdout , test_sdout) ;


parameter ARRAY_SIZE = 6'd20 ;
parameter COUNTER_DEPTH = 7'd10 ;


input reset ;
input clock ;
input sdout ;
output mclk ;
output sclk ;
output lrck ;
output sdin ;
output test_sdout ;

reg [ARRAY_SIZE-1:0] l_fpga_to_codec, r_fpga_to_codec ,l_codec_to_fpga , r_codec_to_fpga ;
wire [COUNTER_DEPTH:0] w4 ;

clkgen 		cod1 ( clock , reset , mclk , sclk , lrck , w4 ) ;
interface  in1 ( clock , reset , mclk , sclk , lrck , w4 , sdin , l_fpga_to_codec , r_fpga_to_codec , sdout , r_codec_to_fpga , l_codec_to_fpga , test_sdout ) ;
filter 		fil1 ( clock , reset , mclk , sclk , lrck , w4 , l_codec_to_fpga , r_codec_to_fpga, l_fpga_to_codec, r_fpga_to_codec) ;

endmodule   
