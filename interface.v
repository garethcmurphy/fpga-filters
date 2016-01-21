module interface(
			clock, 
			reset, 
			mclk, 
			sclk, 
			lrck, 
			seq, 
			sdin, 
			l_fpga_to_codec, 
			r_fpga_to_codec, 
			sdout, 
			r_codec_to_fpga, 
			l_codec_to_fpga, 
			test_sdout);
parameter ARRAY_SIZE = 6'd20;
parameter SHIFT_REG = 6'd32;
parameter COUNTER_DEPTH = 7'd10;

input clock; 
input reset; 
input mclk; 
input sclk; 
input lrck; 
input [COUNTER_DEPTH:0] seq; 
output sdin; reg sdin;
input [ARRAY_SIZE - 1:0] l_fpga_to_codec; 
input [ARRAY_SIZE - 1:0] r_fpga_to_codec; 
input sdout; 
output [ARRAY_SIZE - 1:0] r_codec_to_fpga; reg [ARRAY_SIZE - 1:0] r_codec_to_fpga;
output [ARRAY_SIZE - 1:0] l_codec_to_fpga; 
output test_sdout; reg test_sdout;

reg [SHIFT_REG - 1:0] l_in_shift;
reg [SHIFT_REG - 1:0] r_in_shift;
wire [SHIFT_REG - 1:0] l_out_shift;
reg [SHIFT_REG - 1:0] r_out_shift;
reg [SHIFT_REG - 1:0] l_out_shift_int;
reg [SHIFT_REG - 1:0] r_out_shift_int;
/*
Shift the data into 32-bit registers 
*/
always
  @(posedge sclk) begin
    if (reset == 1'b1) begin
      if (lrck == 0) begin
        l_in_shift[SHIFT_REG - 1:0] <= {l_in_shift[30:0], sdout};
      end
      else if (lrck == 1'b1) begin
        r_in_shift[SHIFT_REG - 1:0] <= {r_in_shift[30:0], sdout};
      end
    end
  end
/*
Data shifted out onto sdin pin to codec
on falling edge of shift clock
Continuously happening until seq exceeds 1D8
then value to be sent to codec is updated

*/
always
  @(negedge sclk) begin
    if (reset == 1'b1) begin
      if (seq < 11'h1D8) begin
        if (lrck == 0) begin
          sdin <= l_out_shift_int[SHIFT_REG - 1];
        end
        else if (lrck == 1) begin
          sdin <= r_out_shift_int[SHIFT_REG - 1];
          r_out_shift_int[SHIFT_REG - 1:0] <= {r_out_shift_int[30:0], r_out_shift_int[SHIFT_REG - 1]};
        end
      end
      else if (seq > 11'h1D8) begin
        r_out_shift[30:11] <= r_fpga_to_codec[ARRAY_SIZE - 1:0];
        r_out_shift_int[SHIFT_REG - 1:0] <= r_out_shift[SHIFT_REG - 1:0];
      end
    end
  end

assign l_codec_to_fpga[ARRAY_SIZE - 1:0] = l_in_shift[30:11];
always
  @(negedge lrck) begin
    r_codec_to_fpga[ARRAY_SIZE - 1:0] <= r_in_shift[30:11];
  end

endmodule // interface

