`timescale 1ns / 1ps

module division (
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] outDiv
);

localparam [15:0] one = 16'b0011111110000000;

reg [15:0] reciporical2;

// Calculate reciprocal of the divisor
reciporical r1 (
    .numerator(one),
    .divisor(divisor),
    .reciporical1(reciporical2)
);

// Multiply dividend by the reciprocal
mul mulReciporical (
    .flp_a(dividend),
    .flp_b(reciporical2),
    .sign(outDiv[15]),
    .exponent(outDiv[14:10]),
    .prod(outDiv[9:0])
);

endmodule
