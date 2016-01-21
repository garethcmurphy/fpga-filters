module clkgen ( clock , reset , mclk, sclk, lrck, seq ) ;

parameter RESET_TIME  =11'd511 ;
parameter COUNTER_DEPTH1 = 7'd10 ;

input clock ;
input reset ;
output mclk ;
output sclk ;
output lrck ;
output [COUNTER_DEPTH1:0] seq ;

reg mclk , sclk , lrck;
reg reset ;
reg [COUNTER_DEPTH1:0 ] seq  ;

always @ (posedge clock )
begin
	if (reset )
	begin
		 if ( seq == RESET_TIME   )
			begin
				seq <= 0;
			end
	else 
		begin
			seq <= seq + 1 ;
		end
	mclk <= seq [0] ;
	sclk <= seq [2] ;
	lrck <= seq [8] ;
end
end

endmodule

