`timescale 1ns / 1ps

module reciprocal (
    input [15:0] numerator,
    input [15:0] divisor,
    output [15:0] reciporical1
);
localparam size = 16;
localparam constant1 = 16'b0010110011010111; // 48/17
localparam constant2 = 16'b1101110101100000; // -32/17

wire [15:0] D;
wire [15:0] numerator1;
wire [15:0] divisor1;
wire sign;
wire [15:0] X0;
wire [15:0] xi1;
wire [15:0] xi2;
wire [15:0] xi3;
wire [15:0] xi4;
wire [15:0] xi5;
wire [15:0] xi6;
wire [15:0] X0add;

assign sign = numerator[15] ^ divisor[15]; // xor the sign of numerator and divisor
assign numerator1[15] = 1'b0;
assign divisor1[15] = 1'b0;
assign numerator1[14:10] = numerator[14:10] - 1 - divisor[14:10] + 15'b0111111; // 127 biased
assign divisor1[14:10] = 5'b11110; // 30 biased
assign numerator1[9:0] = numerator[9:0];
assign divisor1[9:0] = divisor[9:0];
assign D = divisor1;

// Calculate Xo through 48/17-32/17 * divisor1              
mul mulD (
    .flp_a(divisor1),
    .flp_b(constant2),
    .sign(X0[15]),
    .exponent(X0[14:10]),
    .prod(X0[9:0])
);

add additionX0 (
    .A_FP(constant1),
    .B_FP(X0),
    .out(X0add)
);

// Calculate Xn from first 4 terms of X = X * (2-D*X)              
Xncalculation firstterm (
    .D(D),
    .X(X0add),
    .Xn(xi1)
);
Xncalculation secondterm (
    .D(D),
    .X(xi1),
    .Xn(xi2)
);
Xncalculation thirdterm (
    .D(D),
    .X(xi2),
    .Xn(xi3)
);
Xncalculation forthterm (
    .D(D),
    .X(xi3),
    .Xn(xi4)
);

// Calculate multiply of Numerator with Xn value
mul mulNumeratorDivisor (
    .flp_a(xi4),
    .flp_b(numerator1),
    .sign(reciporical1[15]),
    .exponent(reciporical1[14:10]),
    .prod(reciporical1[9:0])
);

endmodule
