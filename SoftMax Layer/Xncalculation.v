`timescale 1ns / 1ps

module Xncalculation (
    input [15:0] D,
    input [15:0] X,
    output reg [15:0] Xn
);

localparam [15:0] two = 16'b0100000000000000; // value of 2

reg [15:0] term1;
reg [15:0] term2;
reg [15:0] term3;
reg [15:0] x1;

// Calculate term1: D * X
mul mul1(
    .flp_a(D),
    .flp_b(X),
    .sign(term1[15]),
    .exponent(term1[14:10]),
    .prod(term1[9:0])
);

// Calculate term2: 2 - term1
assign term2 = two - term1;

// Calculate term3: X * term2
mul mul2(
    .flp_a(X),
    .flp_b(term2),
    .sign(Xn[15]),
    .exponent(Xn[14:10]),
    .prod(Xn[9:0])
);

endmodule
