`timescale 1ns / 1ps

module term (
    input [15:0] originalNum,
    input [15:0] poweredNum,
    input [15:0] reciporical,
    output [15:0] outPower,
    output [15:0] outTerm
);

wire [15:0] t;

mul mulPower(
    .flp_a(originalNum),
    .flp_b(poweredNum),
    .sign(outPower[15]),
    .exponent(outPower[14:11]),
    .prod(outPower[10:0])
);

assign t = outPower;

mul mulTerm(
    .flp_a(t),
    .flp_b(reciporical),
    .sign(outTerm[15]),
    .exponent(outTerm[14:11]),
    .prod(outTerm[10:0])
);

endmodule

