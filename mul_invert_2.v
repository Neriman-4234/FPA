module mul_invert_2(
input i_clk,i_rst,i_start,
input [31:0] i_operand_a,
input [31:0] i_operand_b,
output reg [31:0] o_operand_o,
output o_exception,o_overflow,o_underflow,
output reg o_done
);

wire overflow,underflow;
reg [8:0] exponent;
wire [8:0] sum_exponent;
reg [22:0] product_mantissa;
wire [23:0] op_a,op_b;
reg [47:0] product;
wire [47:0] product_normalised;
reg [31:0] temp_o;
wire sign,normalised,zero;
wire exception,round;


assign o_exception = exception;
assign o_overflow  = overflow;
assign o_underflow = underflow;

//////////////////////////////////////////////////////////
assign sign = i_operand_a[31] ^ i_operand_b[31];				// XOR of 32nd bit
assign exception = (&i_operand_a[30:23]) | (&i_operand_b[30:23]); // Execption sets to 1 when exponent of any a or b is 255
// If exponent is 0, hidden bit is 0
assign op_a = (|i_operand_a[30:23]) ? {1'b1,i_operand_a[22:0]} : {1'b0,i_operand_a[22:0]};
assign op_b = (|i_operand_b[30:23]) ? {1'b1,i_operand_b[22:0]} : {1'b0,i_operand_b[22:0]};

assign normalised = product[47] ? 1'b1 : 1'b0;
assign product_normalised = normalised ? product : product << 1;
assign round = |product_normalised[22:0];
assign zero = exception ? 1'b0 : (product_mantissa == 23'd0) ? 1'b1 : 1'b0;
assign sum_exponent = i_operand_a[30:23] + i_operand_b[30:23];
assign overflow = ((exponent[8] & !exponent[7]) & !zero); 									// Overall exponent is greater than 255 then Overflow
assign underflow = ((exponent[8] & exponent[7]) & !zero) ? 1'b1 : 1'b0; 							// Sum of exponents is less than 255 then Underflow

always@(posedge i_clk,posedge i_rst) begin

if(i_rst) begin
o_operand_o <= 32'b0;
exponent <= 8'b0;
product_mantissa <= 23'b0;
product <= 48'b0;
end
else begin

 product <= op_a * op_b;
 product_mantissa <= product_normalised[46:24] + (product_normalised[23] & round);
 exponent <= sum_exponent - 8'd127 + normalised;
 o_operand_o <= exception ? 32'd0 : zero ? {sign,31'd0} : overflow ? {sign,8'hFF,23'd0} : underflow ? {sign,31'd0} : {sign,exponent[7:0],product_mantissa};

end

end

/////////////////////////////////////////////////////////
endmodule
