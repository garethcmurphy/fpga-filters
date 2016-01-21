/*
Gareth Murphy
e98bf01b
98372840
Hardware Software Co-design
Testbench for 7-Segment LED Generator 
4th Year Engineering
*/

module testbench_led ;
wire Load_val, a,b,c,d ;
reg  [3:0] hex_input;
wire [6:0] led_output ;
ck_gen c1(Load_val);
led led1 (Load_val,  hex_input,led_output );
initial begin
//$monitor ("led_output %b" , led_output);
hex_input=4'b0000;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b0001;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b0010;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b " , led_output);
hex_input=4'b0011;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b0100;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b0101;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b0110;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b0111;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b " , led_output);
hex_input=4'b1000;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b1001;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);hex_input=4'b1010;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b1011;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b1100;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b " , led_output);
hex_input=4'b1101;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b1110;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);
hex_input=4'b1111;
$write ("hex_input %b %h" , hex_input ,hex_input);
#17
$display ("\tled_output %b" , led_output);

end
endmodule
