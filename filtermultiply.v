module filter(
			clock, 
			reset, 
			mclk, 
			sclk, 
			lrck, 
			seq, 
			l_codec_to_fpga, 
			r_codec_to_fpga, 
			l_fpga_to_codec, 
			r_fpga_to_codec);
parameter COUNTER_DEPTH1 = 7'd10;
parameter ARRAY_WIDTH = 7'd20;
parameter COEFF_WIDTH = 10'd8;
input clock; 
input reset; 
input mclk; 
input sclk; 
input lrck; 
input [COUNTER_DEPTH1:0] seq; 
input [ARRAY_WIDTH - 1:0] l_codec_to_fpga; 
input [ARRAY_WIDTH - 1:0] r_codec_to_fpga; 
output [ARRAY_WIDTH - 1:0] l_fpga_to_codec; reg [ARRAY_WIDTH - 1:0] l_fpga_to_codec;
output [ARRAY_WIDTH - 1:0] r_fpga_to_codec; reg [ARRAY_WIDTH - 1:0] r_fpga_to_codec;
parameter divisor = 2'd11;
parameter coeff1 = 8'hF4;
parameter coeff2 = 8'hFC;
parameter coeff3 = 8'h18;
parameter coeff4 = 8'h33;
reg [ARRAY_WIDTH:0] r_tap1;
reg [ARRAY_WIDTH:0] r_tap2;
reg [ARRAY_WIDTH:0] r_tap3;
reg [ARRAY_WIDTH:0] r_tap4;
reg [ARRAY_WIDTH:0] r_tap5;
reg [ARRAY_WIDTH:0] r_tap6;
reg [ARRAY_WIDTH:0] r_tap7;
reg [ARRAY_WIDTH:0] r_tap8;
wire [ARRAY_WIDTH - 1:0] r_factor1;
wire [ARRAY_WIDTH - 1:0] r_factor2;
wire [ARRAY_WIDTH - 1:0] r_factor3;
wire [ARRAY_WIDTH - 1:0] r_factor4;
wire [ARRAY_WIDTH - 1:0] r_factor5;
wire [ARRAY_WIDTH - 1:0] r_factor6;
wire [ARRAY_WIDTH - 1:0] r_factor7;
wire [ARRAY_WIDTH - 1:0] r_factor8;
reg [ARRAY_WIDTH - 1:0] r_temp;
mult_tc m1 (coeff1, r_tap1[ARRAY_WIDTH - 1:12], r_factor1[ARRAY_WIDTH - 1:4]);
mult_tc m2 (coeff2, r_tap2[ARRAY_WIDTH - 1:12], r_factor2[ARRAY_WIDTH - 1:4]);
mult_tc m3 (coeff3, r_tap3[ARRAY_WIDTH - 1:12], r_factor3[ARRAY_WIDTH - 1:4]);
mult_tc m4 (coeff4, r_tap4[ARRAY_WIDTH - 1:12], r_factor4[ARRAY_WIDTH - 1:4]);
mult_tc m5 (coeff4, r_tap5[ARRAY_WIDTH - 1:12], r_factor5[ARRAY_WIDTH - 1:4]);
mult_tc m6 (coeff3, r_tap6[ARRAY_WIDTH - 1:12], r_factor6[ARRAY_WIDTH - 1:4]);
mult_tc m7 (coeff2, r_tap7[ARRAY_WIDTH - 1:12], r_factor7[ARRAY_WIDTH - 1:4]);
mult_tc m8 (coeff1, r_tap8[ARRAY_WIDTH - 1:12], r_factor8[ARRAY_WIDTH - 1:4]);

always
  @(negedge lrck) begin
    if (reset == 1'b1) begin
      l_fpga_to_codec[ARRAY_WIDTH - 1:0] <= 0;
    end
  end

always
  @(posedge lrck) begin
    if (reset) begin
      r_tap1 <= {r_codec_to_fpga[ARRAY_WIDTH - 2], r_codec_to_fpga[ARRAY_WIDTH - 2], r_codec_to_fpga[ARRAY_WIDTH - 2:0]};
      r_tap2 <= r_tap1;
      r_tap3 <= r_tap2;
      r_tap4 <= r_tap3;
      r_tap5 <= r_tap4;
      r_tap6 <= r_tap5;
      r_tap7 <= r_tap6;
      r_tap8 <= r_tap7;
      r_temp <= r_factor1 + r_factor2 + r_factor3 + r_factor4 + r_factor5 + r_factor6 + r_factor7 + r_factor8;
      r_fpga_to_codec[ARRAY_WIDTH - 1:0] <= {r_temp[ARRAY_WIDTH - 1:0]};
    end
  end

endmodule // filter

