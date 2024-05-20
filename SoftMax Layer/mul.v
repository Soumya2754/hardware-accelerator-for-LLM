`timescale 1ns / 1ps

module mul (
    input [15:0] flp_a,
    input [15:0] flp_b,
    output reg sign,
    output reg [7:0] exponent,
    output reg [9:0] prod
);

reg [19:0] x;
assign prod = x[19:10];
always @* begin
    if (flp_a == 0 || flp_b == 0) begin
        sign = 0;
        x = 0;
        exponent = 0;
        prod = 0;
    end else begin
        sign = flp_a[15] ^ flp_b[15];
        x = {1'b1, flp_a[10:0]} * {1'b1, flp_b[10:0]};
        exponent = flp_a[14:11] + flp_b[14:11] - 15 + 1;
        if (x[20]) begin
            x = x >> 1;
            exponent = exponent + 1;
        end
    end
end

endmodule
