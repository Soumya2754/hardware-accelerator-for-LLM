`timescale 1ns / 1ps

module Softmax_Layer (
    input [10:0][15:0] inputData, // Array of 1024 elements, each 16 bits
    output [10:0][15:0] outData,  // Array of 1024 elements, each 16 bits
    output [15:0] chosenProbability // Chosen probability
);

localparam sizeArr = 10;
localparam width = 16;
localparam one = 16'b0011110000000000; // Example value for "one" in 16-bit float representation

wire [10:0][15:0] exponentialArr1;
wire [15:0] total1;
wire [15:0] recp;
wire [10:0][15:0] exponentialArr2;
wire [10:0][15:0] exponentialArr3;
wire [10:0][15:0] Output_Arr;
wire [10:0][15:0] max1;

genvar i;

// Calculate exponential for each input array element
generate
    for (i = 0; i < sizeArr; i = i + 1) begin
        exponential E (
            .inputX(inputData[i]),
            .outputY(exponentialArr1[i])
        );
        assign exponentialArr2[i] = exponentialArr1[i];
    end
endgenerate

// Accumulator for summing exponentials
generate
    for (i = 0; i < sizeArr; i = i + 1) begin : add
        add add1 (
            .A_FP(Output_Arr[i]),
            .B_FP(exponentialArr1[i]),
            .out(Output_Arr[i+1])
        );
    end
endgenerate

assign total1 = Output_Arr[sizeArr];

// Calculate reciprocal of the sum of exponentials
reciporical r1 (
    .numerator(one),
    .divisor(total1),
    .reciporical1(recp)
);

// Normalize exponentials to get softmax probabilities
generate
    for (i = 0; i < sizeArr; i = i + 1) begin
        mul div (
            .flp_a(exponentialArr2[i]),
            .flp_b(recp[i]),
            .sign(outData[i][width-1]),
            .exponent(outData[i][14:10]),
            .prod(outData[i][9:0])
        );
        assign exponentialArr3[i] = outData[i];
    end
endgenerate

// Calculate maximum value in the array
assign max1[0] = exponentialArr3[0];
generate
    for (i = 1; i < sizeArr; i = i + 1) begin
        maxValue max1V (
            .in1(max1[i-1]),
            .in2(exponentialArr3[i]),
            .outmax(max1[i])
        );
    end
endgenerate

assign chosenProbability = max1[sizeArr-1];

endmodule
