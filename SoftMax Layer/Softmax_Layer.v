module Softmax_Layer (
    input [1023:0][15:0] inputData, // Array of 1024 elements, each 16 bits
    output [1023:0][15:0] outData,  // Array of 1024 elements, each 16 bits
    output [15:0] chosenProbability // Chosen probability
);

localparam sizeArr = 1024;
localparam width = 16;
localparam one = 16'b0011110000000000; // Example value for "one" in 16-bit float representation

wire [1023:0][15:0] exponentialArr1;
wire [15:0] total1;
wire [15:0] recp;
wire [1023:0][15:0] exponentialArr2;
wire [1023:0][15:0] exponentialArr3;
wire [1023:0][15:0] Output_Arr;
wire [1023:0][15:0] max1;

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

// Distribute the reciprocal value across the array
generate
    for (i = 1; i < sizeArr; i = i + 1) begin
        assign recp[i+1] = recp[i];
    end
endgenerate

// Normalize exponentials to get softmax probabilities
generate
    for (i = 0; i < sizeArr; i = i + 1) begin
        mul div (
            .flp_a(exponentialArr2[i]),
            .flp_b(recp[i]),
            .sign(outData[i][width-1]),
            .exponent(outData[i][width-2+:7]),
            .prod(outData[i][width-9 -:23])
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
