module Multiplication(
    input [15:0] a_operand,
    input [15:0] b_operand,
    output Exception, Overflow, Underflow,
    output [31:0] result
);

wire sign, product_round, normalised, zero;
wire [4:0] exponent, sum_exponent;
wire [10:0] product_mantissa;
wire [11:0] operand_a, operand_b;
wire [23:0] product, product_normalised;

assign sign = a_operand[15] ^ b_operand[15];
assign Exception = (&a_operand[14:10]) | (&b_operand[14:10]);

assign operand_a = (|a_operand[14:10]) ? {1'b1, a_operand[9:0]} : {1'b0, a_operand[9:0]};
assign operand_b = (|b_operand[14:10]) ? {1'b1, b_operand[9:0]} : {1'b0, b_operand[9:0]};

assign product = operand_a * operand_b;
assign product_round = |product_normalised[10:0];
assign normalised = product[23] ? 1'b1 : 1'b0;
assign product_normalised = normalised ? product : product << 1;

assign product_mantissa = product_normalised[10:0] + (product_normalised[0] & product_round);
assign zero = Exception ? 1'b0 : (product_mantissa == 11'd0) ? 1'b1 : 1'b0;

assign sum_exponent = a_operand[14:10] + b_operand[14:10];
assign exponent = sum_exponent - 5'd15 + normalised;

assign Overflow = ((exponent[5] & !exponent[4]) & !zero);
assign Underflow = ((exponent[5] & exponent[4]) & !zero) ? 1'b1 : 1'b0;

assign result = Exception ? 32'd0 : zero ? {sign, 31'd0} : Overflow ? {sign, 8'hFF, 23'd0} : Underflow ? {sign, 31'd0} : {sign, exponent[4:0], product_mantissa};

endmodule
