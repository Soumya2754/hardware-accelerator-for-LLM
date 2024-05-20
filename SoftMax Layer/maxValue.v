`timescale 1ns / 1ps

module maxValue (
    input [15:0] in1,
    input [15:0] in2,
    output reg [15:0] outmax
);

reg [15:0] max = 16'b0000000000000000;

always @* begin
    if (in1[14:11] > in2[14:11])
        max = in1;
    else if (in1[14:11] < in2[14:11])
        max = in2;
    else if (in1[14:11] == in2[14:11]) begin
        if (in1[10:0] > in2[10:0])
            max = in1;
        else if (in1[10:0] < in2[10:0])
            max = in2;
        else
            max = in1;
    end
end

assign outmax = max;

endmodule
